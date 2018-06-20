class CreateSongs < RevertableMigration

  self.content_type_id = 'song'

  def up
    with_space do |space|
      content_type = space.content_types.create(
        name: 'Song',
        id: content_type_id,
        description: 'An individual song'
      )

      content_type.fields.create(id: 'title', name: 'Title', type: 'Symbol', required: true)
      content_type.fields.create(id: 'slug', name: 'Slug', type: 'Symbol', required: true, validations: [uniqueness_of])
      content_type.fields.create(id: 'description', name: 'Description', type: 'Text')
      content_type.fields.create(id: 'details', name: 'Details', type: 'Text')
      content_type.fields.create(id: 'lyrics', name: 'Lyrics', type: 'Text')
      content_type.fields.create(id: 'chords', name: 'Chords', type: 'Text')
      content_type.fields.create(id: 'stems', name: 'Stems', type: 'Text')

      items = Contentful::Management::Field.new
      items.type = 'Symbol'
      content_type.fields.create(id: 'tags', name: 'Tags', type: 'Array', items: items)

      content_type.fields.create(id: 'category', name: 'Category', type: 'Link', link_type: 'Entry', validations: [validation_of_type('category')])
      content_type.fields.create(id: 'author', name: 'Author', type: 'Array', items: items_of_type('Entry', 'author'))

      content_type.fields.create(id: 'audio_duration', name: 'Audio Duration', type: 'Text')
      content_type.fields.create(id: 'album', name: 'Album', type: 'Link', link_type: 'Entry', validations: [validation_of_type('author')])
      content_type.fields.create(id: 'image', name: 'Image', type: 'Link', link_type: 'Asset', required: true)
      content_type.fields.create(id: 'bg_image', name: 'Background Image', type: 'Link', link_type: 'Asset', required: true)
      content_type.fields.create(id: 'spotify_url', name: 'Spotify URL', type: 'Symbol')
      content_type.fields.create(id: 'apple_music_url', name: 'Apple Music URL', type: 'Symbol')
      content_type.fields.create(id: 'google_play_url', name: 'Google Play URL', type: 'Symbol')
      content_type.fields.create(id: 'youtube_url', name: 'YouTube URL', type: 'Symbol')
      content_type.fields.create(id: 'published_at', name: 'Published At', type: 'Date', required: true)
      content_type.fields.create(id: 'related_videos', name: 'Related Videos', type: 'Array', items: items_of_type('Entry', 'video'))

      content_type.save
      content_type.publish
      apply_editor(space, 'slug', 'slugEditor')
    end
  end

end