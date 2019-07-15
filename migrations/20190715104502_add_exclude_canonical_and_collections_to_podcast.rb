class AddExcludeCanonicalAndCollectionsToPodcast < ContentfulMigrations::Migration
  include MigrationUtils

  def up
    with_space do |space|
      content_type = space.content_types.find('podcast')
      content_type.fields.create(id: 'exclude_from_crossroads', name: 'Exclude from crossroads.net?', type: 'Boolean')
      validation_for_type = Contentful::Management::Validation.new
      validation_for_type.in = ['www.crossroads.net', 'www.briantome.com']
      content_type.fields.create(id: 'canonical_host', name: 'Canonical Host', type: 'Symbol', validations: [validation_for_type])
      content_type.save
      content_type.publish

      editor_interface = content_type.editor_interface.default
      controls = editor_interface.controls
      field = controls.detect { |e| e['fieldId'] == 'canonical_host' }
      field['widgetId'] = "dropdown"
      field['settings'] = { 'helpText' => 'If blank, content will be canonicalized to crossroads.net' }
      editor_interface.update(controls: controls)
      editor_interface.reload
      content_type.save
      content_type.publish

      content_type.fields.create(id: 'collections', name: 'Collections', type: 'Array', items: items_of_type('Entry', 'collection'))
      content_type.save
      content_type.publish
    end
  end

  def down
    with_space do |space|
      content_type = space.content_types.find('podcast')
      %w(exclude_from_crossroads canonical_host collections).each do |id|
        field = content_type.fields.detect { |f| f.id == id }
        field.omitted = true
        field.disabled = true
        content_type.save
        content_type.activate
        content_type.fields.destroy(id)
      end
    end
  end
end


