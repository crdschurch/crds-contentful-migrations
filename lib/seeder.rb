require 'yaml'
require 'contentful/management'
require 'active_support/all'

class Seeder

  class << self
    def seed!(options = {})
      files = Dir.glob('data/**/*')

      contentful = Contentful::Management::Client.new(ENV['CONTENTFUL_MANAGEMENT_ACCESS_TOKEN'])
      environment = contentful.environments(ENV['CONTENTFUL_SPACE_ID']).find(ENV['CONTENTFUL_ENV'] || 'master')
      content_types = environment.content_types.all.map { |t| [t.id, t] }.to_h

      puts 'Fetching assets ...'
      asset_request = environment.assets.all(limit: 1000)
      assets = asset_request.to_a
      (asset_request.total / 1000).times do
        puts 'Fetching next page ...'
        asset_request = asset_request.next_page
        assets.concat(asset_request.to_a)
      end
      assets.select! { |a| a.file }.compact

      content_types.each do |id, obj|
        puts "Fetching entries for content type: #{id} ..."
        entry_request = environment.entries.all(limit: 1000, content_type: id)
        entries = entry_request.to_a
        (entry_request.total / 1000).times do
          puts 'Fetching next page ...'
          entry_request = entry_request.next_page
          entries.concat(entry_request.to_a)
        end
        content_types[id] = {
          entries: entries,
          obj: obj
        }
      end

      # binding.pry

      files.each do |file|
        body = File.read(file)
        raw_frontmatter = body.match(/^---(.|\n)*?---/)[0]
        frontmatter = YAML.load(raw_frontmatter)
        body.slice!(raw_frontmatter)
        body.strip!

        content_type = frontmatter['_content_type']
        frontmatter[frontmatter['_body_field'] || 'body'] = body if body
        frontmatter.keys.select { |k| k.start_with?('_') }.map { |k| frontmatter.delete(k) }
        frontmatter.symbolize_keys!

        frontmatter.each do |k, v|
          next unless v.is_a?(Hash) && %w{asset entry entries}.include?(v['type'])
          attachment = case v['type']
          when 'asset'
            assets.detect { |a| a.file.url == v['url'] }
          when 'entry'
            content_types[v['content_type']][:entries].detect { |e| e.fields[v['field'].to_sym] == v['value'] }
          when 'entries'
            content_types[v['content_type']][:entries]
              .select { |e| v['values'].include?(e.fields[v['field'].to_sym]) }
              .sort_by { |e| v['values'].index(e.fields[v['field'].to_sym]) }
          end
          frontmatter[k] = attachment if attachment
        end

        entry = content_types[content_type][:obj].entries.create(frontmatter)
        entry.publish
      end
    end
  end

end
