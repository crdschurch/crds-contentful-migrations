class CreateEpisodes < RevertableMigration

  self.content_type_id = 'episode'

  def up
    with_space do |space|
      content_type = space.content_types.create(
        name: 'Episode',
        id: content_type_id,
        description: 'A podcast episode'
      )

      content_type.fields.create(id: 'title', name: 'Title', type: 'Symbol', required: true)
      content_type.fields.create(id: 'slug', name: 'Slug', type: 'Symbol', required: true, validations: [uniqueness_of])
      content_type.fields.create(id: 'description', name: 'Description', type: 'Text')
      content_type.fields.create(id: 'podcast', name: 'Postcast', type: 'Link', link_type: 'Entry', required: true, validations: [validation_of_type('podcast')])
      content_type.fields.create(id: 'episode_number', name: 'Episode Number', type: 'Integer')
      content_type.fields.create(id: 'season_number', name: 'Season Number', type: 'Integer')
      content_type.fields.create(id: 'published_at', name: 'Published At', type: 'Date', required: true)
      content_type.fields.create(id: 'category', name: 'Category', type: 'Link', link_type: 'Entry', required: true, validations: [validation_of_type('category')])

      items = Contentful::Management::Field.new
      items.type = 'Symbol'
      content_type.fields.create(id: 'tags', name: 'Tags', type: 'Array', items: items)

      content_type.fields.create(id: 'show_notes', name: 'Show Notes', type: 'Text')
      content_type.fields.create(id: 'transcription', name: 'Transcription', type: 'Text')
      content_type.fields.create(id: 'audio_duration', name: 'Audio Duration (mins)', type: 'Integer')
      content_type.fields.create(id: 'audio_embed_code', name: 'Audio Embed Code', type: 'Text')

      content_type.save
      content_type.publish
      apply_editor(content_type, 'slug', 'slugEditor')
    end
  end

end