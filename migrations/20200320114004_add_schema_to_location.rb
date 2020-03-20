class AddSchemaToLocation < ContentfulMigrations::Migration
  def up
    with_space do |space|
      content_type = space.content_types.find('location')
      content_type.fields.create(id: 'schema', name: 'Schema', type: 'Object')
      content_type.save
      content_type.publish
    end
  rescue Exception => e
    binding.pry
  end
  def down
    with_space do |space|
      content_type = space.content_types.find('location')
      field = content_type.fields.detect { |f| f.id == 'schema' }
      field.omitted = true
      field.disabled = true
      content_type.save
      content_type.publish
    end
  end
end
