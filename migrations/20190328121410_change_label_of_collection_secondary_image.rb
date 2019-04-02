class ChangeLabelOfCollectionSecondaryImage < ContentfulMigrations::Migration

  def up
    with_space do |space|
      content_type = space.content_types.find('collection')
      field = content_type.fields.detect { |f| f.id == 'secondary_image' }
      field.name = 'Home Page Feature Image'
      content_type.save
      content_type.publish

      # Set Editor UI
      editor_interface = content_type.editor_interface.default
      controls = editor_interface.controls
      controls.detect { |c| c['fieldId'] == 'secondary_image' }['settings'] = { 'helpText' => 'displays on media landing page, when featured.' }
      editor_interface.update(controls: controls)
      editor_interface.reload
      content_type.save
      content_type.publish
    end
  end

  def down
    with_space do |space|
      content_type = space.content_types.find('collection')
      field = content_type.fields.detect { |f| f.id == 'secondary_image' }
      field.name = 'Secondary Image'
      content_type.save
      content_type.publish

      # Set Editor UI
      editor_interface = content_type.editor_interface.default
      controls = editor_interface.controls
      controls.detect { |c| c['fieldId'] == 'secondary_image' }['settings'] = { 'helpText' => '' }
      editor_interface.update(controls: controls)
      editor_interface.reload
      content_type.save
      content_type.publish
    end
  end
end
