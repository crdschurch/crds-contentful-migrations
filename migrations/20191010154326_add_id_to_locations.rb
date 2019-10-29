class AddIdToLocations < ContentfulMigrations::Migration

  def up
    with_space do |space|
      content_type = space.content_types.find('location')
      content_type.fields.create(id: 'site_id', name: 'Site ID', type: 'Number', required: true)
      content_type.save
      content_type.publish
    end
  end

  def down
    with_space do |space|
      content_type = space.content_types.find('location')

      field = content_type.fields.detect { |f| f.id == 'site_id' }
      field.omitted = true
      field.disabled = true

      content_type.save
      content_type.activate
      content_type.fields.destroy('site_id')
      content_type.save
      content_type.publish
    end
  end
end

