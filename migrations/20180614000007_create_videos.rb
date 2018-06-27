class CreateVideos < RevertableMigration

  self.content_type_id = 'video'

  def up
    with_space do |space|
      content_type = space.content_types.create(
        name: 'Video',
        id: content_type_id,
        description: 'An individual video'
      )

      content_type.fields.create(id: 'title', name: 'Title', type: 'Symbol', required: true)
      content_type.fields.create(id: 'slug', name: 'Slug', type: 'Symbol', required: true, validations: [uniqueness_of])
      content_type.fields.create(id: 'subtitle', name: 'Subtitle', type: 'Symbol')
      content_type.fields.create(id: 'description', name: 'Description', type: 'Text')
      content_type.fields.create(id: 'author', name: 'Author', type: 'Array', items: items_of_type('Entry', 'author'))
      content_type.fields.create(id: 'image', name: 'Image', type: 'Link', link_type: 'Asset', required: true)
      content_type.fields.create(id: 'source_link', name: 'Source URL', type: 'Symbol')
      content_type.fields.create(id: 'video_duration', name: 'Video Duration', type: 'Symbol')
      content_type.fields.create(id: 'category', name: 'Category', type: 'Link', link_type: 'Entry', validations: [validation_of_type('category')])
      content_type.fields.create(id: 'transcription', name: 'Transcription', type: 'Text')
      content_type.fields.create(id: 'apple_podcasts_url', name: 'Apple Podcasts URL', type: 'Symbol')
      content_type.fields.create(id: 'google_play_url', name: 'Google Play URL', type: 'Symbol')
      content_type.fields.create(id: 'view_count', name: 'View Count', type: 'Number', disabled: true)

      items = Contentful::Management::Field.new
      items.type = 'Symbol'
      content_type.fields.create(id: 'tags', name: 'Tags', type: 'Array', items: items)
      content_type.fields.create(id: 'published_at', name: 'Published At', type: 'Date', required: true)

      content_type.save
      content_type.publish
      apply_editor(space, 'slug', 'slugEditor')
    end
  end

end