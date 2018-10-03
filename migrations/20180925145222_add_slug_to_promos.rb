class AddSlugToPromos < ContentfulMigrations::Migration
  include MigrationUtils
  def up
    with_space do |space|
      content_type = space.content_types.find('promo')
      content_type.fields.create(id: 'slug', name: 'Slug', type: 'Symbol', required: true, validations: [uniqueness_of])
      content_type.save
      content_type.publish

      # Set Editor UI
      with_editor_interfaces do |editor_interfaces|
        editor_interface = editor_interfaces.default(space_id, 'promo')
        controls = editor_interface.controls
        controls.detect { |e| e['fieldId'] == 'slug' }['settings'] = { 'helpText' => 'This must be a unique value' }
        controls.detect { |e| e['fieldId'] == 'slug' }['widgetId'] = "slugEditor"
        editor_interface.update(controls: controls)
        editor_interface.reload
      end
      
      content_type.save
      content_type.publish
    end
  end

  def down
    with_space do |space|
      content_type = space.content_types.find('promo')

      field = content_type.fields.detect { |f| f.id == 'slug' }
      field.omitted = true
      field.disabled = true

      content_type.save
      content_type.activate
      content_type.fields.destroy('slug')
    end
  end
end
