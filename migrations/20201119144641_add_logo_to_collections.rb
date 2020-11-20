class AddLogoToCollections < ContentfulMigrations::Migration
  def up
    with_space do |space|
      content_type = space.content_types.find('collection')
      content_type.fields.create(id: 'logo', name: 'Logo', type: 'Link', link_type: 'Asset')
      content_type.save
      content_type.publish      
    end
  end

  def down
    with_space do |space|
      content_type = space.content_types.find('collection')

      field = content_type.fields.detect { |f| f.id == 'logo' }
      field.omitted = true
      field.disabled = true

      content_type.save
      content_type.activate
      content_type.fields.destroy('logo')
      content_type.save
      content_type.publish
    end
  end
end
