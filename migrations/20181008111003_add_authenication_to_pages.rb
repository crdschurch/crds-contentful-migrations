class AddAuthenticationToPages < ContentfulMigrations::Migration

  include MigrationUtils

  def up
    with_space do |space|
      content_type = space.content_types.find('page')
      
      content_type.fields.create(id: 'requires_auth', name: 'Requires Authentication?', type: 'Boolean')

      # Set Editor UI
      with_editor_interfaces do |editor_interfaces|
        editor_interface = editor_interfaces.default(space_id, 'page')
        controls = editor_interface.controls
        controls.detect { |e| e['fieldId'] == 'requires_auth' }['settings'] = { 'helpText' => 'Does the user need to be logged in to see this page?' }
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
      field = content_type.fields.detect { |f| f.id == 'requires_auth' }
      field.omitted = true
      field.disabled = true

      content_type.save
      content_type.activate
      content_type.fields.destroy('requires_auth')
    end
  end

end
