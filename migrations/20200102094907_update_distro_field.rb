class UpdateDistroField < ContentfulMigrations::Migration
  def content_types
    %w(album article content_block category collection episode message meta page podcast redirect series song video)
  end

  def up
    with_space do |space|
      content_types.each do |name|
        content_type = space.content_types.find(name)

        widget_id = {
          'development' => '7pen61ICvT0RvmFXRepZa3',
          'int' => '2XO3c2aXJj0MDelzxDwB3f',
          'demo' => '1MzJ8eqfVidEFElMG2DIPS',
          'master' => '4ZENvJxZkqJreQMNHEruk6'
        }[ENV['CONTENTFUL_ENV'] || 'master']

        editor_interface = content_type.editor_interface.default
        controls = editor_interface.controls
        field = controls.detect { |c| c['fieldId'] == 'distribution_channels' }
        if field
          field['widgetNamespace'] = 'extension'
          field['widgetId'] = widget_id
          editor_interface.update(controls: controls)
          editor_interface.reload
        end
      end
    end
  end

  def down
    with_space do |space|
      content_types.each do |name|
        content_type = space.content_types.find(name)

        editor_interface = content_type.editor_interface.default
        controls = editor_interface.controls
        field = controls.detect { |c| c['fieldId'] == 'distribution_channels' }
        if field
          field['widgetNamespace'] = 'builtin'
          field['widgetId'] = 'objectEditor'
          editor_interface.update(controls: controls)
          editor_interface.reload
        end
      end
    end
  end
end
