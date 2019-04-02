require_relative '../lib/revertable_migration'

class CreateCollections < RevertableMigration

  self.content_type_id = 'collection'

  def up
    with_space do |space|
      content_type = space.content_types.create(
        name: 'Collection',
        id: content_type_id,
        description: 'Collections of media'
      )

      content_type.fields.create(id: 'title', name: 'Title', type: 'Symbol', required: true)
      content_type.fields.create(id: 'description', name: 'Description', type: 'Text')
      content_type.fields.create(id: 'image', name: 'Image', type: 'Link', link_type: 'Asset')
      content_type.save
      content_type.publish
    end
  end
end
