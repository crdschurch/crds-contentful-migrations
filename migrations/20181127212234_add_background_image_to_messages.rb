class AddBackgroundImageToMessages < ContentfulMigrations::Migration
  include MigrationUtils

  def up
    with_space do |space|
      content_type = space.content_types.find('message')
      content_type.fields.create(id: 'background_image', name: 'Background Image', type: 'Link', link_type: 'Asset')
      content_type.save
      content_type.publish
    end
  end

  def down
    with_space do |space|
      content_type = space.content_types.find('message')

      field = content_type.fields.detect { |f| f.id == 'background_image' }
      field.omitted = true
      field.disabled = true

      content_type.save
      content_type.activate
      content_type.fields.destroy('background_image')
      content_type.save
      content_type.publish
    end
  end
end