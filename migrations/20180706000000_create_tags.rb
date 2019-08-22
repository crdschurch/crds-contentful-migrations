class CreateTags < RevertableMigration

  self.content_type_id = 'tag'

  def up
    with_space do |space|
      content_type = space.content_types.create(
        name: 'Tag',
        id: content_type_id,
        description: 'Content is organized by tags'
      )

      content_type.fields.create(id: 'title', name: 'Title', type: 'Symbol', required: true, validations: [uniqueness_of])
      content_type.fields.create(id: 'slug', name: 'Slug', type: 'Symbol', required: true, validations: [uniqueness_of])

      content_type.save
      content_type.publish
      apply_editor(content_type, 'slug', 'slugEditor')
    end
  end

  def down
    with_space do |space|
      content_type = space.content_types.find('tag')
      content_type.deactivate
      content_type.destroy
    end
  end
end