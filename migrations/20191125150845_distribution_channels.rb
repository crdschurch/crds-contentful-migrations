class DistributionChannels < ContentfulMigrations::Migration

  class << self
    attr_accessor :content_types
    attr_accessor :field_id
  end

  def initialize(name = self.class.name, version = nil, client = nil, space = nil)
    super(name, version, client, space)
    @content_types = %w(album article category content_block episode message meta page podcast redirect series song video)
    @field_id = 'distribution_channels'
  end

  def up
    with_space do |space|
      @content_types.each do |content_type|
        content_type = space.content_types.find(content_type)
        content_type.fields.create(id: @field_id, name: 'Distribution Channels', type: 'Object')
        content_type.save
        content_type.publish
      end

      %w(article category podcast video).each do |type_id|
        content_type = space.content_types.find(type_id)
        %w(exclude_from_crossroads canonical_host).each do |field_id|
          field = content_type.fields.detect { |f| f.id == field_id }
          field.disabled = true
        end
        content_type.save
        content_type.publish
      end
    end
  end

  def down
    with_space do |space|
      @content_types.each do |content_type|
        content_type = space.content_types.find(content_type)
        field = content_type.fields.detect { |f| f.id == @field_id }
        field.omitted = true
        field.disabled = true
        content_type.save
        content_type.publish
        content_type.fields.destroy(@field_id)
      end

      %w(article category podcast video).each do |type_id|
        content_type = space.content_types.find(type_id)
        %w(exclude_from_crossroads canonical_host).each do |field_id|
          field = content_type.fields.detect { |f| f.id == field_id}
          field.disabled = false
        end
        content_type.save
        content_type.publish
      end
    end
  end
end
