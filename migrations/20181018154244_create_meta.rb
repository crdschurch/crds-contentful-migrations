class CreateMeta < RevertableMigration

  self.content_type_id = 'meta'

  def up
    with_space do |space|
      content_type = space.content_types.create(
        name: 'Meta',
        id: content_type_id,
        description: 'Meta objects for entries'
      )

      content_type.fields.create(id: 'title', name: 'Title', type: 'Symbol', required: true)
      content_type.fields.create(id: 'description', name: 'Description', type: 'Text')
      content_type.fields.create(id: 'image', name: 'Image', type: 'Link', link_type: 'Asset', required: true)

      content_type.save
      content_type.publish
    end
  end

end
