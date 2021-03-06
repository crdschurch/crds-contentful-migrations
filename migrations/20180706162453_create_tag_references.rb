class CreateTagReferences < ContentfulMigrations::Migration
  include MigrationUtils

  def up
    with_space do |space|
      content_types = %w[article episode video message song]

      content_types.each do |name|
        content_type = space.content_types.find(name)

        content_type.fields.create(id: 'tags', name: 'Tags', type: 'Array', items: items_of_type('Entry', 'tag'))

        content_type.save
        content_type.publish
      end
    end
  end

  def down
    with_space do |space|
      content_types = %w[article episode video message song]

      content_types.each do |name|
        content_type = space.content_types.find(name)

        field = content_type.fields.detect { |f| f.id == 'tags' }
        field.omitted = true
        field.disabled = true

        content_type.save
        content_type.activate
        content_type.fields.destroy('tags')
        content_type.save
      end
    end
  end
end