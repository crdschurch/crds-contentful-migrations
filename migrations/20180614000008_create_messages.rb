class CreateMessages < RevertableMigration

  self.content_type_id = 'message'

  def up
    with_space do |space|
      content_type = space.content_types.create(
        name: 'Message',
        id: content_type_id,
        description: 'An individual message from a series'
      )

      content_type.fields.create(id: 'title', name: 'Title', type: 'Symbol', required: true)
      content_type.fields.create(id: 'slug', name: 'Slug', type: 'Symbol', required: true, validations: [uniqueness_of])
      content_type.fields.create(id: 'subtitle', name: 'Subtitle', type: 'Symbol')
      content_type.fields.create(id: 'description', name: 'Description', type: 'Text')
      content_type.fields.create(id: 'author', name: 'Author', type: 'Array', items: items_of_type('Entry', 'author'))
      content_type.fields.create(id: 'image', name: 'Image', type: 'Link', link_type: 'Asset')
      content_type.fields.create(id: 'source_url', name: 'Source URL', type: 'Symbol')
      content_type.fields.create(id: 'audio_source_url', name: 'Audio Source URL', type: 'Symbol')
      content_type.fields.create(id: 'program', name: 'PDF Program', type: 'Link', link_type: 'Asset')
      content_type.fields.create(id: 'video_duration', name: 'Message Duration', type: 'Symbol')
      content_type.fields.create(id: 'category', name: 'Category', type: 'Link', link_type: 'Entry', validations: [validation_of_type('category')])

      items = Contentful::Management::Field.new
      items.type = 'Symbol'
      content_type.fields.create(id: 'tags', name: 'Tags', type: 'Array', items: items)

      content_type.fields.create(id: 'transcription', name: 'Transcription', type: 'Text')
      content_type.fields.create(id: 'apple_podcasts_url', name: 'Apple Podcasts URL', type: 'Symbol')
      content_type.fields.create(id: 'google_play_url', name: 'Google Play URL', type: 'Symbol')
      content_type.fields.create(id: 'published_at', name: 'Published At', type: 'Date', required: true)

      content_type.save
      content_type.publish
      apply_editor(space, 'slug', 'slugEditor')
    end
  end

end