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

      request = environment.assets.all(limit: 1000)
      assets = request.to_a

      (request.total / 1000).times do
        request = request.next_page
        assets.concat(request.to_a)
      end

      assets.select! { |a| a.file }.compact

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
          next unless v.start_with?('//')
          asset = assets.detect { |a| a.file.url == v }
          frontmatter[k] = asset if asset
        end

        entry = content_types[content_type].entries.create(frontmatter)
        entry.publish
      end
    end
  end

end
