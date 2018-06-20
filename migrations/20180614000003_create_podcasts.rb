class CreatePodcasts < RevertableMigration

  @@content_type_id = 'podcast'

  def up
    with_space do |space|
      content_type = space.content_types.create(
        name: 'Podcast',
        id: content_type_id,
        description: 'Podcast, or a grouping of audio episodes'
      )

      content_type.fields.create(id: 'title', name: 'Title', type: 'Symbol', required: true)
      content_type.fields.create(id: 'slug', name: 'Slug', type: 'Symbol', required: true, validations: [uniqueness_of])
      content_type.fields.create(id: 'subtitle', name: 'Subtitle', type: 'Symbol')
      content_type.fields.create(id: 'description', name: 'Description', type: 'Text')
      content_type.fields.create(id: 'image', name: 'Image', type: 'Link', link_type: 'Asset', required: true)
      content_type.fields.create(id: 'bg_image', name: 'Background Image', type: 'Link', link_type: 'Asset', required: true)
      content_type.fields.create(id: 'author', name: 'Author', type: 'Array', items: items_of_type('Entry', 'author'))
      content_type.fields.create(id: 'apple_podcasts_url', name: 'Apple Podcasts URL', type: 'Symbol')
      content_type.fields.create(id: 'google_play_url', name: 'Google Play URL', type: 'Symbol')
      content_type.fields.create(id: 'stitcher_url', name: 'Stitcher URL', type: 'Symbol')

      content_type.save
      content_type.publish
      apply_editor(space, 'slug', 'slugEditor')
    end
  end

end