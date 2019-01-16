require 'yaml'
require 'contentful/management'
require 'active_support/all'

class Seeder

  class << self
    attr_accessor :assets, :entries

    def seed!(options = {})
      files = Dir.glob('data/**/*')

      contentful = Contentful::Management::Client.new(ENV['CONTENTFUL_MANAGEMENT_ACCESS_TOKEN'])
      environment = contentful.environments(ENV['CONTENTFUL_SPACE_ID']).find(ENV['CONTENTFUL_ENV'] || 'master')
      content_types = environment.content_types.all.map { |t| [t.id, t] }.to_h

      puts 'Fetching assets ...'
      asset_request = environment.assets.all(limit: 1000)
      self.assets = asset_request.to_a
      (asset_request.total / 1000).times do
        puts 'Fetching next page ...'
        asset_request = asset_request.next_page
        assets.concat(asset_request.to_a)
      end
      assets.select! { |a| a.file }.compact

      puts 'Fetching entries ...'
      entry_request = environment.entries.all(limit: 1000)
      self.entries = entry_request.to_a
      (entry_request.total / 1000).times do
        puts 'Fetching next page ...'
        entry_request = entry_request.next_page
        entries.concat(entry_request.to_a)
      end

      # binding.pry

      files.each do |file|
        body = File.read(file)
        raw_frontmatter = body.match(/^---(.|\n)*?---/)[0]
        frontmatter = YAML.load(raw_frontmatter)
        body.slice!(raw_frontmatter)
        body.strip!

        content_type = frontmatter['_content_type']
        linked_fields = frontmatter['_linked_fields']
        frontmatter[frontmatter['_body_field'] || 'body'] = body if body
        frontmatter.keys.select { |k| k.start_with?('_') }.map { |k| frontmatter.delete(k) }
        frontmatter.symbolize_keys!

        frontmatter.each do |k, v|
          next unless [v].flatten.first.match(/^(asset|entry):/)
          attachments = [v].flatten.map { |a| send(a.split(':').first.pluralize).detect { |x| x.id == a.split(':').last } }
          frontmatter[k] = v.is_a?(Array) ? attachments : attachments.first if attachments
        end

        entry = content_types[content_type].entries.create(frontmatter)
        entry.publish
      end
    end
  end

end
