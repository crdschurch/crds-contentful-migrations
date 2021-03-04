class AddLocationsToOnsiteGroupMeeting < ContentfulMigrations::Migration
  def up
    with_space do |space|
      content_type = space.content_types.find('onsite_group_meeting')
      content_type.fields.create(id: 'locations', name: 'Locations', type: 'Array', items: items_of_type('Entry', ['location']))
    end
  end

  def down
    with_space do |space|
      content_type = space.content_types.find('onsite_group_meeting')
      field = content_type.fields.detect { |f| f.id == 'locations' }
      field.omitted = true
      field.disabled = true
      content_type.save
      content_type.fields.destroy('locations')
      content_type.save
      content_type.publish
    end
  end
end
