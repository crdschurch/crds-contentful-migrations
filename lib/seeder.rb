require 'yaml'
require 'contentful/management'
require 'active_support/all'

class Seeder

  # Loop through all .md files in the data directory, read the file, then
  # attempt to create and publish an entry in Contentful.
  #
  def self.seed!(options = {})
    Dir.glob('data/**/*').each do |file|
      seed = Seed.new(file)
      seed.parse_file!
      seed.create_entry!
      seed.publish_entry!
      STDOUT.write('.')
    end
    STDOUT.write("\n")
  end

end

class Seed
  attr_accessor :body,
                :entry,
                :fields,
                :frontmatter,
                :raw

  def initialize(file_path)
    @file_path = file_path
    self.raw = File.read(file_path)
  end

  # Read the seed file and set the frontmatter, fields, and body.
  #
  def parse_file!
    extract_body!
    extract_frontmatter!
    extract_fields!
    self
  end

  # Create an entry in Contentful and store a reference to it.
  #
  def create_entry!
    self.entry = content_type.entries.create(fields)
  end

  # Publish the Contentful entry.
  #
  def publish_entry!
    entry.publish
  end

  private

    # Extract body content -- content that is not the frontmatter -- from the
    # file.
    #
    def extract_body!
      self.body = raw.clone
      body.slice!(raw_frontmatter)
      body.strip!
    end

    # Extract frontmatter as a Ruby has with symbolized keys.
    #
    def extract_frontmatter!
      self.frontmatter = YAML.load(raw_frontmatter).deep_symbolize_keys
    end

    # Use the frontmatter to product fields for the Contentful entry. This
    # requires removing any keys that are prepended with an underscore, then
    # parsing any linked entries, along with the body.
    #
    def extract_fields!
      return if fields
      self.fields = frontmatter.clone
      fields.keys.select { |k| k.to_s.start_with?('_') }.map { |k| fields.delete(k) }
      parse_field_links!
      set_body_field!
    end

    # Iterate over the fields hash looking for linkable entries and assets.
    # Retrieve linked objects and set the field value to the Contentful object.
    #
    def parse_field_links!
      fields.each do |k, v|
        field = content_type.fields.detect { |f| f.id == k.to_s }
        next unless field && %w(Link Array).include?(field.type) && [v].flatten.first.is_a?(String)
        next unless link_type = field.link_type || field.items.link_type
        attachments = [v].flatten.map { |id| contentful.send(link_type.downcase.pluralize).find(id) }.compact
        fields[k] = v.is_a?(Array) ? attachments : attachments.first if attachments
      end
    end

    # The body field is configurable through frontmatter metadata (_body_field),
    # otherwise it falls back to body. If the field is already set, don't
    # attempt to set it again. It also doesn't get set if there is no body.
    #
    def set_body_field!
      body_field = frontmatter[:_body_field] || 'body'
      return if fields[body_field.to_sym]
      fields[body_field.to_sym] = body if body.present?
    end

    # Extract raw frontmatter from the file.
    #
    def raw_frontmatter
      @raw.match(/^---(.|\n)*?---/)[0]
    end

    # Contentful client for accessing the Contentful Management API.
    #
    def contentful
      @contentful ||= begin
        client = Contentful::Management::Client.new(ENV['CONTENTFUL_MANAGEMENT_ACCESS_TOKEN'])
        client.environments(ENV['CONTENTFUL_SPACE_ID']).find(ENV['CONTENTFUL_ENV'] || 'master')
      end
    end

    # Content type object from Contentful library.
    #
    def content_type
      @content_type ||= contentful.content_types.find(_content_type)
    end

    # Frontmatter keys can be accessed directly as dynamic methods on the seed
    # instance.
    #
    def method_missing(m, *args, &block)
      frontmatter.symbolize_keys[m.to_sym] || super
    end

    def respond_to_missing?(method_name, include_private = false)
      frontmatter.symbolize_keys.keys.include?(method_name.to_sym) || super
    end

end
