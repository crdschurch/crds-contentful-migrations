class AddDescriptionToAlbum < ContentfulMigrations::Migration

  include MigrationUtils

  def up
    with_space do |space|
      content_type = space.content_types.find('album')
      content_type.fields.create(id: 'description', name: 'Description', type: 'Text')
      content_type.save
      content_type.publish
    end
  end

  def down
    with_space do |space|
      content_type = space.content_types.find('album')
      field = content_type.fields.detect { |f| f.id == 'description' }
      field.omitted = true
      field.disabled = true
      content_type.save
      content_type.publish
      content_type.fields.destroy('description')
      content_type.save
      content_type.publish
    end
  end

end
