class UpdateSong < RevertableMigration

  def up

    with_space do |space|

      content_type = space.content_types.find('song')

      # Delete Fields
      content_type.fields.destroy('description')
      content_type.fields.destroy('details')
      content_type.fields.destroy('chords')
      content_type.fields.destroy('category')
      content_type.fields.destroy('author')
      content_type.fields.destroy('audio_duration')
      content_type.fields.destroy('album')
      content_type.fields.destroy('image')
      content_type.fields.destroy('related_videos')
      content_type.fields.destroy('tags')
      content_type.fields.destroy('published_at')
      content_type.fields.destroy('unpublished_at')
      content_type.fields.destroy('soundcloud_url')
      content_type.fields.destroy('call_to_action')
      content_type.fields.destroy('featured_subtitle')
      content_type.fields.destroy('featured_label')
      content_type.fields.destroy('duration')
      content_type.fields.destroy('collections')

      content_type.save
      content_type.publish

      # Create Fields
      content_type.fields.create(id: 'ccli_number', name: 'CCLI Number', type: 'Symbol', required: true)
      content_type.fields.create(id: 'written_by', name: 'Written By', type: 'Symbol', required: true)
      content_type.fields.create(id: 'song_select_url', name: 'Song Select Url', type: 'Link', required: true)
      content_type.fields.create(id: 'video', name: 'Video', type: 'Link', link_type: 'Asset', validations: [require_mime_type(:video)])
      content_type.fields.create(id: 'lyric_file', name: 'Lyric File', type: 'Link', link_type: 'Asset')
      content_type.fields.create(id: 'chords_file', name: 'Chords File', type: 'Link', link_type: 'Asset')

      content_type.save
      content_type.publish

      apply_editor(space, 'slug', 'slugEditor')

    end
  end
end