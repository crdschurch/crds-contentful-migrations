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

      files.each do |file|
        body = File.read(file)
        raw_frontmatter = body.match(/^---(.|\n)*?---/)[0]
        frontmatter = YAML.load(raw_frontmatter)
        body.slice!(raw_frontmatter)
        body.strip!

        content_type = content_types[frontmatter['_content_type']]
        linked_fields = frontmatter['_linked_fields']
        frontmatter[frontmatter['_body_field'] || 'body'] = body if body
        frontmatter.keys.select { |k| k.start_with?('_') }.map { |k| frontmatter.delete(k) }
        frontmatter.symbolize_keys!

        frontmatter.each do |k,v|
          field = content_type.fields.detect { |f| f.id == k.to_s }
          next unless field && %w(Link Array).include?(field.type)
          next unless link_type = field.link_type || field.items.link_type
          attachments = [v].flatten.map { |id| environment.send(link_type.downcase.pluralize).find(id) }.compact
          frontmatter[k] = v.is_a?(Array) ? attachments : attachments.first if attachments
        end

        entry = content_type.entries.create(frontmatter)
        entry.publish
      end
    end
  end

end
