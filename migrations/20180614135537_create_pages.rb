class CreatePages < RevertableMigration

  @content_type_id = 'page'

  def up
    with_space do |space|
      content_type = space.content_types.create(
        name: 'Page',
        id: @@content_type_id,
        description: 'A piece of content distinguished by a unique path'
      )
      content_type.fields.create(id: 'title', name: 'Title', type: 'Symbol', required: true)
      content_type.fields.create(id: 'slug', name: 'Slug', type: 'Symbol', required: true, validations: [uniqueness_of])
      content_type.fields.create(id: 'body', name: 'Body', type: 'Text')

      validation_in = Contentful::Management::Validation.new
      validation_in.in = ['default']
      content_type.fields.create(id: 'layout', name: 'Layout', type: 'Symbol', required: true, validations: [validation_in])

      content_type.save
      content_type.publish
      apply_editor(space, 'slug', 'slugEditor')
    end
  end

end