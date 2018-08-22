class CreateFeaturedMedia < RevertableMigration

  self.content_type_id = 'featured_media'

  def up
    with_space do |space|
      content_type = space.content_types.create(
        name: 'Featured Media',
        id: content_type_id,
        description: 'Manually control media entries to feature on specific pages'
      )
      featureable_content_types = %w{album article episode message podcast series song video}

      content_type.fields.create(id: 'title', name: 'Title', type: 'Symbol', required: true)
      content_type.fields.create(id: 'path', name: 'Page Path', type: 'Symbol', required: true)
      content_type.fields.create(id: 'entries', name: 'Entries', type: 'Array', items: items_of_type('Entry', featureable_content_types))

      content_type.save
      content_type.publish

      with_editor_interfaces do |editor_interfaces|
        editor_interface = editor_interfaces.default(space.id, content_type_id)
        controls = editor_interface.controls
        controls.detect { |e| e['fieldId'] == 'path' }['settings'] = { 'helpText' => 'e.g. /music' }
        editor_interface.update(controls: controls)
        editor_interface.reload
      end

      content_type.save
      content_type.publish
    end
  end

end
