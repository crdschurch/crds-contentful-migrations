class CreatePerspectiveSet < RevertableMigration

  self.content_type_id = 'perspective_set'

  def up
    with_space do |space|
      content_type = space.content_types.create(
        name: 'Perspective Set',
        id: content_type_id,
        description: 'A group of perspectives for a given week'
      )

      content_type.fields.create(id: 'title', name: 'Title', type: 'Symbol', required: true)
      content_type.fields.create(id: 'slug', name: 'Slug', type: 'Symbol', required: true, validations: [uniqueness_of])
      content_type.fields.create(id: 'image', name: 'Image', type: 'Link', link_type: 'Asset')
      content_type.fields.create(id: 'perspectives', name: 'Perspectives', type: 'Array', items: items_of_type('Entry', ['perspective']))
      content_type.fields.create(id: 'published_at', name: 'Published At', type: 'Date', required: true)
      content_type.fields.create(id: 'meta', name: 'Meta', type: 'Link', link_type: 'Entry', validations: [validation_of_type('meta')])

      content_type.save
      content_type.publish

      apply_editor(space, 'slug', 'slugEditor')

      content_type.save
      content_type.publish
    end
  end

end
