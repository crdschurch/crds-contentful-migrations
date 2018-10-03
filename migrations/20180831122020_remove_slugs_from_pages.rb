class RemoveSlugsFromPages < ContentfulMigrations::Migration

  include MigrationUtils

  def up
    with_space do |space|
      content_type = space.content_types.find('page')
      field = content_type.fields.detect { |f| f.id == 'slug' }
      field.omitted = true
      field.disabled = true
      content_type.save
      content_type.fields.destroy('slug')
      content_type.save
      content_type.publish
    end


    # Set Editor UI
    with_editor_interfaces do |editor_interfaces|
      editor_interface = editor_interfaces.default(space.id, 'page')
      controls = editor_interface.controls
      controls.detect { |e| e['fieldId'] == 'permalink' }['settings'] = { 'helpText' => "Path to the page e.g. '/care/weddings/'" }
      
      editor_interface.update(controls: controls)
      editor_interface.reload
    end

  end
end
