class AddVisibilityFlagToLocations < ContentfulMigrations::Migration
  def up
    with_space do |space|
      content_type = space.content_types.find('location')
      content_type.fields.create(id: 'is_visible', name: 'Visible on locations page?', type: 'Boolean')
      content_type.save
      content_type.publish
    end
  end

  def down
    with_space do |space|
      content_type = space.content_types.find('location')
      field = content_type.fields.detect { |f| f.id == 'is_visible' }
      field.omitted = true
      field.disabled = true

      content_type.save
      content_type.activate
      content_type.fields.destroy('is_visible')
    end
  end
end
