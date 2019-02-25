require_relative '../lib/revertable_migration'

class CreateSearchWidgets < RevertableMigration

  self.content_type_id = 'search_widget'

  def up
    with_space do |space|
      content_type = space.content_types.create(
        name: 'Search Widget',
        id: content_type_id,
        description: 'Custom search results'
      )

      content_type.fields.create(id: 'title', name: 'Title', type: 'Symbol', required: true)
      content_type.fields.create(id: 'url', name: 'URL', type: 'Symbol')
      content_type.fields.create(id: 'body', name: 'Body', type: 'Text')
      content_type.fields.create(id: 'image', name: 'Image URL', type: 'Symbol')
      content_type.fields.create(id: 'date', name: 'Date', type: 'Date')
      content_type.fields.create(id: 'tags', name: 'Tags', type: 'Array', items: items_of_type('Entry', 'tag'))

      content_type.save
      content_type.publish
    end
  end

end
