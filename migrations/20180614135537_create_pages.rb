class CreatePages < RevertableMigration

  self.content_type_id = 'page'

  def up
    with_space do |space|
      content_type = space.content_types.create(
        name: 'Page',
        id: content_type_id,
        description: 'A piece of content distinguished by a unique path'
      )
      validation_for_meta_description = Contentful::Management::Validation.new
      validation_for_meta_description.size = { min: 100, max: 155 }
      validation_for_layout = Contentful::Management::Validation.new
      validation_for_layout.in = ['container-fluid', 'container', 'eight-column']

      content_type.fields.create(id: 'title', name: 'Title', type: 'Symbol', required: true)
      content_type.fields.create(id: 'slug', name: 'Slug', type: 'Symbol', required: true, validations: [uniqueness_of])
      content_type.fields.create(id: 'body', name: 'Body', type: 'Text')
      content_type.fields.create(id: 'show_header', name: 'Show Header?', type: 'Boolean', required: true)
      content_type.fields.create(id: 'show_footer', name: 'Show Footer?', type: 'Boolean', required: true)
      content_type.fields.create(id: 'meta_image', name: 'Meta Image', type: 'Link', link_type: 'Asset')
      content_type.fields.create(id: 'meta_description', name: 'Meta Description', type: 'Symbol', validations: [validation_for_meta_description])
      content_type.fields.create(id: 'layout', name: 'Layout', type: 'Symbol', required: true, validations: [validation_for_layout])

      items = Contentful::Management::Field.new
      items.type = 'Symbol'
      content_type.fields.create(id: 'tags', name: 'Tags', type: 'Array', items: items)

      content_type.save
      content_type.publish
      apply_editor(content_type, 'slug', 'slugEditor')
    end
  end
end