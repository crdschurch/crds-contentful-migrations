class AddMapImageToLocation < ContentfulMigrations::Migration
  def up
    with_space do |space|
      content_type = space.content_types.find('location')
      content_type.fields.create(id: 'map_image', name: 'Map Image', type: 'Link', link_type: 'Asset')
      content_type.save
      content_type.publish
    end
  end

  def down
    with_space do |space|
      content_type = space.content_types.find('location')

      field = content_type.fields.detect { |f| f.id == 'map_image' }
      field.omitted = true
      field.disabled = true

      content_type.save
      content_type.activate
      content_type.fields.destroy('map_image')
      content_type.save
      content_type.publish
    end
  end
end
