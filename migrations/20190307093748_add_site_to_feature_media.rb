class AddSiteToFeatureMedia < ContentfulMigrations::Migration

  include MigrationUtils

  def up
    with_space do |space|
      content_type = space.content_types.find('featured_media')
      validation_for_site = Contentful::Management::Validation.new
      validation_for_site.in = ['net', 'media']
      content_type.fields.create(id: 'site', name: 'Site', type: 'Symbol', required: true, validations: [validation_for_site])

      editor_interface = content_type.editor_interface.default
      controls = editor_interface.controls
      controls.detect { |c| c['fieldId'] == 'site' }['widgetId'] = 'dropdown'
      editor_interface.update(controls: controls)
      editor_interface.reload

      content_type.save
      content_type.publish
    end
  end

  def down
    with_space do |space|
      content_type = space.content_types.find('featured_media')

      field = content_type.fields.detect { |f| f.id == 'site' }
      field.omitted = true
      field.disabled = true

      content_type.save
      content_type.activate
      content_type.fields.destroy('site')
    end
  end
end
