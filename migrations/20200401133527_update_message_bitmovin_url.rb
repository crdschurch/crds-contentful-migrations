class UpdateMessageBitmovinUrl < ContentfulMigrations::Migration
  include MigrationUtils

  def up
    with_space do |space|
    content_type = space.content_types.find('message')
    field = content_type.fields.detect { |f| f.id == 'bitmovin_url'}
    field.required = true

    content_type.save
    content_type.publish
    end
  end

  def down
    with_space do |space|
      content_type = space.content_types.find('message')
      field = content_type.fields.detect { |f| f.id == 'bitmovin_url'}
      field.required = false
  
      content_type.save
      content_type.publish
      end
  end

end
