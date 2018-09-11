class AddAppFieldsToDiscussions < ContentfulMigrations::Migration
  include MigrationUtils

  def up
    with_space do |space|
      content_type = space.content_types.find('discussion')

      content_type.fields.create(id: 'image', name: 'Image', type: 'Link', link_type: 'Asset', validations: [require_mime_type(:image)])
      content_type.fields.create(id: 'duration', name: 'Duration (mins)', type: 'Integer')

      content_type.save
      content_type.publish
    end
  end

  def down
    with_space do |space|
      content_type = space.content_types.find('discussion')

      field = content_type.fields.detect { |f| f.id == 'image' }
      field.omitted = true
      field.disabled = true

      field = content_type.fields.detect { |f| f.id == 'duration' }
      field.omitted = true
      field.disabled = true

      content_type.save
      content_type.activate
      content_type.fields.destroy('image')
      content_type.fields.destroy('duration')
    end
  end

end