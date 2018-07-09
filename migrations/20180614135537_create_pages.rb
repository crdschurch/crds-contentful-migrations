class CreatePages < RevertableMigration

  self.content_type_id = 'page'

  def up
    with_space do |space|
      content_type = space.content_types.create(
        name: 'Page',
        id: content_type_id,
        description: 'A piece of content distinguished by a unique path'
      )
      content_type.fields.create(id: 'title', name: 'Title', type: 'Symbol', required: true)
      content_type.fields.create(id: 'slug', name: 'Slug', type: 'Symbol', required: true, validations: [uniqueness_of])
      content_type.fields.create(id: 'body', name: 'Body', type: 'Text')
      content_type.fields.create(id: 'show_header', name: 'Show Header?', type: 'Boolean', required: true)
      content_type.fields.create(id: 'show_footer', name: 'Show Footer?', type: 'Boolean', required: true)
      content_type.fields.create(id: 'meta_description', name: 'Meta Description', type: 'Symbol') # to be reflected in a Page content model's SSG-emitted web page metadata (e.g. <meta name="description" value="meta_description">)

      validation_in = Contentful::Management::Validation.new
      validation_in.in = ['container-fluid', 'container', 'eight-column']
      content_type.fields.create(id: 'layout', name: 'Layout', type: 'Symbol', required: true, validations: [validation_in])

      items = Contentful::Management::Field.new
      items.type = 'Symbol'
      content_type.fields.create(id: 'tags', name: 'Tags', type: 'Array', items: items)

      content_type.save
      content_type.publish
      apply_editor(space, 'slug', 'slugEditor')
    end
  end
end