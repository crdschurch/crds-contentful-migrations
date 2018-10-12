class CreatePerspectives < RevertableMigration

  self.content_type_id = 'perspective'

  def up
    with_space do |space|
      content_type = space.content_types.create(
        name: 'Perspective',
        id: content_type_id,
        description: 'Short paragraph reactions to current worldly news events with a different perspective.'
      )

      content_type.fields.create(id: 'title', name: 'Title', type: 'Symbol', required: true)
      content_type.fields.create(id: 'slug', name: 'Slug', type: 'Symbol', required: true, validations: [uniqueness_of])
      content_type.fields.create(id: 'body', name: 'Body', type: 'Text', required: true)
      content_type.fields.create(id: 'image', name: 'Image', type: 'Link', link_type: 'Asset')
      content_type.fields.create(id: 'published_at', name: 'Published At', type: 'Date', required: true)
      content_type.fields.create(id: 'author', name: 'Author', type: 'Link', link_type: 'Entry', required: true, validations: [validation_of_type('author')])
      content_type.fields.create(id: 'tags', name: 'Tags', type: 'Array', items: items_of_type('Entry', 'tag'))
      content_type.fields.create(id: 'discussion', name: 'Discussion', type: 'Link', link_type: 'Entry', validations: [validation_of_type('discussion')])

      content_type.save
      content_type.publish
      apply_editor(space, 'slug', 'slugEditor')
    end
  end
end