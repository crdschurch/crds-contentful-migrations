class AddSecondaryImageToCollections < ContentfulMigrations::Migration
  def up
    with_space do |space|
      content_type = space.content_types.find('collection')
      content_type.fields.create(id: 'secondary_image', name: 'Secondary Image', type: 'Link', link_type: 'Asset')
      content_type.save
      content_type.publish
    end
  end

  def down
    with_space do |space|
      content_type = space.content_types.find('collection')

      field = content_type.fields.detect { |f| f.id == 'secondary_image' }
      field.omitted = true
      field.disabled = true

      content_type.save
      content_type.activate
      content_type.fields.destroy('secondary_image')
    end
  end
end
