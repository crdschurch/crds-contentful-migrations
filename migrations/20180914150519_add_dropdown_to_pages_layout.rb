class AddDropdownToPagesLayout < ContentfulMigrations::Migration

  include MigrationUtils

  def up
    with_space do |space|
      content_type = space.content_types.find('page')
      
      # Set Editor UI
      with_editor_interfaces do |editor_interfaces|
        editor_interface = editor_interfaces.default(space, 'page')
        controls = editor_interface.controls
        controls.detect { |e| e['fieldId'] == 'layout' }['widgetId'] = "dropdown"
        
        editor_interface.update(controls: controls)
        editor_interface.reload
      end

      content_type.save
      content_type.publish
    end
  end

  def down
    with_space do |space|
      content_type = space.content_types.find('page')
      widgetId = content_type.fields.detect { |f| f.id == 'layout' }['widgetId']
      # reset to single line
      widgetId = "singleLine"
      content_type.save
      content_type.publish
    end
  end

end
