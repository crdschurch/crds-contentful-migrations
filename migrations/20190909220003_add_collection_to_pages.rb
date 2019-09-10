class AddCollectionToPage < ContentfulMigrations::Migration
  include MigrationUtils

  def up
    with_space do |space|
      content_type = space.content_types.find('page')
      content_type.fields.create(id: 'collections', name: 'Collections', type: 'Array', items: items_of_type('Entry', 'collection'))
      content_type.save
      content_type.publish
    end
  end

  def down
    with_space do |space|
      content_type = space.content_types.find('page')
      field = content_type.fields.detect { |f| f.id == 'collections' }
      field.omitted = true
      field.disabled = true
      content_type.save
      content_type.activate
      content_type.fields.destroy(id)
    end
  end
end
