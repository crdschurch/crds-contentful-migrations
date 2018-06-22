class CreateAlbums < RevertableMigration

  self.content_type_id = 'album'

  def up
    with_space do |space|
      content_type = space.content_types.create(
        name: 'Album',
        id: content_type_id,
        description: 'A Crossroads music album'
      )

      content_type.fields.create(id: 'title', name: 'Title', type: 'Symbol', required: true)
      content_type.fields.create(id: 'slug', name: 'Slug', type: 'Symbol', required: true, validations: [uniqueness_of])
      content_type.fields.create(id: 'description', name: 'Description', type: 'Text')
      content_type.fields.create(id: 'image', name: 'Album Artwork', type: 'Link', link_type: 'Asset', required: true)
      content_type.fields.create(id: 'bg_image', name: 'Background Image', type: 'Link', link_type: 'Asset', required: true)
      content_type.fields.create(id: 'author', name: 'Author', type: 'Link', link_type: 'Entry', required: true, validations: [validation_of_type('author')])
      content_type.fields.create(id: 'spotify_url', name: 'Spotify URL', type: 'Symbol')
      content_type.fields.create(id: 'apple_music_url', name: 'Apple Music URL', type: 'Symbol')
      content_type.fields.create(id: 'google_play_url', name: 'Google Play URL', type: 'Symbol')
      content_type.fields.create(id: 'published_at', name: 'Published At', type: 'Date', required: true)

      content_type.save
      content_type.publish
      apply_editor(space, 'slug', 'slugEditor')
    end
  end

end