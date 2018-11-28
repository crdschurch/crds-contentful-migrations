class AddHelpTextToRedirects < ContentfulMigrations::Migration
  include MigrationUtils
  
  def up
    with_space do |space|
      content_type = space.content_types.find('redirect')
      # Set Editor UI
      with_editor_interfaces do |editor_interfaces|
        editor_interface = editor_interfaces.default(ENV['CONTENTFUL_SPACE_ID'], 'redirect')
        controls = editor_interface.controls
        controls.detect { |e| e['fieldId'] == 'from' }['settings'] = { 'helpText' => 'e.g. /clark-kent' }
        controls.detect { |e| e['fieldId'] == 'to' }['settings'] = { 'helpText' => 'e.g. /superman' }
        controls.detect { |e| e['fieldId'] == 'status' }['widgetId'] = "dropdown"
        editor_interface.update(controls: controls)
        editor_interface.reload
      end
      
      content_type.save
      content_type.publish
    end
  end

  def down
    with_space do |space|
      content_type = space.content_types.find('redirect')
      widgetId = content_type.fields.detect { |f| f.id == 'status' }['widgetId']
      # reset to single line
      widgetId = "singleLine"
      content_type.save
      content_type.publish
    end
  end
end
