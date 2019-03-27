class AddTimestampsToMessagesAndVideos < ContentfulMigrations::Migration
  def up
    with_space do |space|
      %w(message video).each do |type|
        content_type = space.content_types.find(type)
        content_type.fields.create(id: 'timestamps', name: 'Timestamps', type: 'Object')
        content_type.save
        content_type.publish

        editor_interface = content_type.editor_interface.default
        controls = editor_interface.controls
        controls.detect { |c| c['fieldId'] == 'timestamps' }['widgetNamespace'] = 'extension'
        controls.detect { |c| c['fieldId'] == 'timestamps' }['widgetId'] = '7ArP5EZMYZWpGH08FIy0IA'
        editor_interface.update(controls: controls)
        editor_interface.reload

        content_type.save
        content_type.publish
      end
    end
  end

  def down
    with_space do |space|
      content_type = space.content_types.find('collection')
      field = content_type.fields.detect { |f| f.id == 'timestamps' }
      field.omitted = true
      field.disabled = true
      content_type.save
      content_type.activate
      content_type.fields.destroy('timestamps')
    end
  end
end
