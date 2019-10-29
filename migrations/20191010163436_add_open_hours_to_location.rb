class AddOpenHoursToLocation < ContentfulMigrations::Migration
  def up
    with_space do |space|
      content_type = space.content_types.find('location')
      content_type.fields.create(id: 'open_hours', name: 'Open Hours', type: 'Text')
      content_type.save
      content_type.publish
    end
  end

  def down
    with_space do |space|
      content_type = space.content_types.find('location')

      field = content_type.fields.detect { |f| f.id == 'open_hours' }
      field.omitted = true
      field.disabled = true

      content_type.save
      content_type.activate
      content_type.fields.destroy('open_hours')
      content_type.save
      content_type.publish
    end
  end
end
