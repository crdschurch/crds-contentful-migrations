class CleanupOsgMeeting < ContentfulMigrations::Migration
  include MigrationUtils
  def up
    with_space do |space|
      content_type = space.content_types.find('onsite_group_meeting')
      content_type.fields.create(id: 'room', name: 'Room', type: 'Symbol')
      content_type.fields.create(id: 'childcare', name: 'Childcare available?', type: 'Boolean')

      editor_interface = content_type.editor_interface.default
      controls = editor_interface.controls

      field = controls.detect { |e| e['fieldId'] == 'starts_at' }
      field['settings'] = { 'format' => 'dateonly' }

      editor_interface.update(controls: controls)
      editor_interface.reload

      content_type.activate
    end
  end

  def down
    with_space do |space|
      content_type = space.content_types.find('onsite_group_meeting')

       fields = [
        'room',
        'childcare'
      ]

      fields.each do |field|
        field = content_type.fields.detect { |f| f.id == field }
        next unless field
        field.omitted = true
        field.disabled = true
      end
      
      content_type.save
      content_type.publish
      
      fields.each do |field|
        content_type.fields.destroy(field)
      end
    end
  end
end
