require_relative '../lib/revertable_migration'

class CreateAuthors < RevertableMigration

  self.content_type_id = 'author'

  def up
    with_space do |space|
      content_type = space.content_types.create(
        name: 'Author',
        id: content_type_id,
        description: 'Person associated with one or more pieces of content'
      )

      content_type.fields.create(id: 'full_name', name: 'Full Name', type: 'Symbol', required: true)
      content_type.fields.create(id: 'slug', name: 'Slug', type: 'Symbol', required: true, validations: [uniqueness_of])
      content_type.fields.create(id: 'summary', name: 'Summary', type: 'Text', required: true)
      content_type.fields.create(id: 'image', name: 'Image', type: 'Link', link_type: 'Asset', required: true)

      content_type.save
      content_type.publish
      apply_editor(content_type, 'slug', 'slugEditor')
    end
  end

end