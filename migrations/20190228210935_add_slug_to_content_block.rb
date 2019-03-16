class AddSlugToContentBlock < ContentfulMigrations::Migration

  include MigrationUtils

  def up
    with_space do |space|
      content_type = space.content_types.find('content_block')
      content_type.fields.create(id: 'slug', name: 'Slug', type: 'Symbol', required: true)
      content_type.save
      content_type.publish

      editor_interface = content_type.editor_interface.default
      controls = editor_interface.controls
      controls.detect { |c| c['fieldId'] == 'slug' }['widgetId'] = 'slugEditor'
      editor_interface.update(controls: controls)
      editor_interface.reload

      content_type.save
      content_type.publish
    end
  end

  def down
    with_space do |space|
      content_type = space.content_types.find('content_block')

      field = content_type.fields.detect { |f| f.id == 'slug' }
      field.omitted = true
      field.disabled = true

      content_type.save
      content_type.activate
      content_type.fields.destroy('slug')
    end
  end
end


