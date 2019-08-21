class CreateCategories < RevertableMigration

  self.content_type_id = 'category'

  def up
    with_space do |space|
      content_type = space.content_types.create(
        name: 'Category',
        id: content_type_id,
        description: 'Content is organized by categories'
      )

      content_type.fields.create(id: 'title', name: 'Title', type: 'Symbol', required: true)
      content_type.fields.create(id: 'slug', name: 'Slug', type: 'Symbol', required: true, validations: [uniqueness_of])
      content_type.fields.create(id: 'body', name: 'Body', type: 'Text')
      content_type.fields.create(id: 'image', name: 'Image', type: 'Link', link_type: 'Asset', required: true)

      content_type.save
      content_type.publish
      apply_editor(content_type, 'slug', 'slugEditor')
    end
  end

end