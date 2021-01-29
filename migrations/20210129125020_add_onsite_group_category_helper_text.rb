class AddOnsiteGroupCategoryHelperText < ContentfulMigrations::Migration
  def up
    with_space do |space|
      content_type = space.content_types.find('onsite_group')
      editor_interface = content_type.editor_interface.default
      controls = editor_interface.controls
      controls.detect { |c| c['fieldId'] == 'category' }['settings'] = { 'helpText' => 'Please note: "Onsite Group Categories" attached to this Onsite Group will determine filtering options on /connect for associated Onsite Group Meetings.' }
      editor_interface.update(controls: controls)
      editor_interface.reload
      content_type.save
      content_type.publish
    end
  end

  def down
    with_space do |space|
      content_type = space.content_types.find('onsite_group')
      editor_interface = content_type.editor_interface.default
      controls = editor_interface.controls
      controls.detect { |c| c['fieldId'] == 'category' }['settings'] = { 'helpText' => '' }
      editor_interface.update(controls: controls)
      editor_interface.reload
      content_type.save
      content_type.publish
    end
  end
end
