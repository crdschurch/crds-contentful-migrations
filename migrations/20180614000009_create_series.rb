class CreateSeries < RevertableMigration

  self.content_type_id = 'series'

  def up
    with_space do |space|
      content_type = space.content_types.create(
        name: 'Series',
        id: content_type_id,
        description: 'A series has many messages'
      )

      content_type.fields.create(id: 'title', name: 'Title', type: 'Symbol', required: true)
      content_type.fields.create(id: 'slug', name: 'Slug', type: 'Symbol', required: true, validations: [uniqueness_of])
      content_type.fields.create(id: 'image', name: 'Image', type: 'Link', link_type: 'Asset', required: true)
      content_type.fields.create(id: 'background_image', name: 'Background Image', type: 'Link', link_type: 'Asset')
      content_type.fields.create(id: 'description', name: 'Description', type: 'Text')
      content_type.fields.create(id: 'starts_at', name: 'Starts', type: 'Date')
      content_type.fields.create(id: 'ends_at', name: 'Ends', type: 'Date')
      content_type.fields.create(id: 'youtube_url', name: 'YouTube URL', type: 'Symbol')
      content_type.fields.create(id: 'apple_podcasts_url', name: 'Apple Podcasts URL', type: 'Symbol')
      content_type.fields.create(id: 'google_play_url', name: 'Google Play URL', type: 'Symbol')
      content_type.fields.create(id: 'videos', name: 'Videos', type: 'Array', items: items_of_type('Entry', ['video', 'message']))
      content_type.fields.create(id: 'published_at', name: 'Published At', type: 'Date', required: true)

      content_type.save
      content_type.publish
      apply_editor(space, 'slug', 'slugEditor')
    end
  end

end