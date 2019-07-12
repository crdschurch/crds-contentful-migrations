class CreateCollectionReferences < ContentfulMigrations::Migration
  include MigrationUtils

  def up
    with_space do |space|
      content_types = %w[article episode video message song podcast]

      content_types.each do |name|
        content_type = space.content_types.find(name)

        content_type.fields.create(id: 'collections', name: 'Collections', type: 'Array', items: items_of_type('Entry', 'collection'))

        content_type.save
        content_type.publish
      end
    end
  end

  def down
    with_space do |space|
      content_types = %w[article episode video message song podcast]

      content_types.each do |name|
        content_type = space.content_types.find(name)

        field = content_type.fields.detect { |f| f.id == 'collections' }
        field.omitted = true
        field.disabled = true

        content_type.save
        content_type.activate
        content_type.fields.destroy('collections')
        content_type.save
      end
    end
  end
end
