class CreateArticles < RevertableMigration

  self.content_type_id = 'article'

  def up
    with_space do |space|
      content_type = space.content_types.create(
        name: 'Article',
        id: content_type_id,
        description: 'Long-form written content, such as a blog post'
      )

      content_type.fields.create(id: 'title', name: 'Title', type: 'Symbol', required: true)
      content_type.fields.create(id: 'slug', name: 'Slug', type: 'Symbol', required: true, validations: [uniqueness_of])
      content_type.fields.create(id: 'body', name: 'Body', type: 'Text', required: true)
      content_type.fields.create(id: 'image', name: 'Image', type: 'Link', link_type: 'Asset', required: true)

      items = Contentful::Management::Field.new
      items.type = 'Symbol'
      content_type.fields.create(id: 'tags', name: 'Tags', type: 'Array', items: items)

      content_type.fields.create(id: 'published_at', name: 'Published At', type: 'Date', required: true)
      content_type.fields.create(id: 'author', name: 'Author', type: 'Link', link_type: 'Entry', required: true, validations: [validation_of_type('author')])
      content_type.fields.create(id: 'category', name: 'Category', type: 'Link', link_type: 'Entry', required: true, validations: [validation_of_type('category')])

      content_type.save
      content_type.publish
      apply_editor(content_type, 'slug', 'slugEditor')
    end
  end

end