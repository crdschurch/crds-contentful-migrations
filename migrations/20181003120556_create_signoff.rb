class CreateSignoff < RevertableMigration

  self.content_type_id = 'signoff'

  def up
    with_space do |space|
      content_type = space.content_types.create(
        name: 'Sign Off',
        id: content_type_id,
        description: 'The sign off is a single entry that allows the admins to apply a global sign off the bottom of all articles.'
      )

      content_type.fields.create(id: 'title', name: 'Title', type: 'Symbol', required: true)
      content_type.fields.create(id: 'published_at', name: 'Published At', type: 'Date', required: true)
      content_type.fields.create(id: 'body', name: 'Body', type: 'Text', required: true)

      content_type.save
      content_type.publish
    end
  end
end