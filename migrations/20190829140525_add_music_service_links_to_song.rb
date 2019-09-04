class AddMusicServiceLinksToSong < ContentfulMigrations::Migration
  def up
    with_space do |space|
      content_type = space.content_types.find('song')

        fields = [
          'song_select_url',
          'chords_file',
          'lyrics_file'
      ]

      fields.each do |field|
        field = content_type.fields.detect { |f| f.id == field }
        next unless field
        field.omitted = true
        field.disabled = true
      end
      
      content_type.save
      content_type.publish
      
      fields.each do |field|
        content_type.fields.destroy(field)
      end

      content_type.fields.create(id: 'music_service_links', name: 'Music service links', type: 'Object')

      content_type.activate

      widget_id = {
        'dev-test' => 'WtteiIZ1SLYNwdpEWrQjt',
        'int' => '3gJG8A9sX5AdbLY9um7GX0',
        'demo' => '19bKTiflHnZLNMUYMj6voB',
        'master' => 'WtteiIZ1SLYNwdpEWrQjt'
      }[ENV['CONTENTFUL_ENV'] || 'master']

      editor_interface = content_type.editor_interface.default
      controls = editor_interface.controls
      controls.detect { |c| c['fieldId'] == 'music_service_links' }['widgetNamespace'] = 'extension'
      controls.detect { |c| c['fieldId'] == 'music_service_links' }['widgetId'] = widget_id
      editor_interface.update(controls: controls)
      editor_interface.reload

    end
  end

  def down
    with_space do |space|
      content_type = space.content_types.find('song')

        fields = [
          'music_service_links'
      ]

      fields.each do |field|
        field = content_type.fields.detect { |f| f.id == field }
        next unless field
        field.omitted = true
        field.disabled = true
      end
      
      content_type.save
      content_type.publish
      
      fields.each do |field|
        content_type.fields.destroy(field)
      end

      content_type.fields.create(id: 'song_select_url', name: 'Song Select Url', type: 'Symbol')
      content_type.fields.create(id: 'lyrics_file', name: 'Lyrics File', type: 'Link', link_type: 'Asset')
      content_type.fields.create(id: 'chords_file', name: 'Chords File', type: 'Link', link_type: 'Asset')

      content_type.activate
    end
  end
end
