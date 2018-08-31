class AddPermalinksToPages < ContentfulMigrations::Migration

  include MigrationUtils

  def up
    with_space do |space|
      content_type = space.content_types.find('page')
      content_type.fields.create(id: 'permalink', name: 'Permalink', type: 'Symbol', required: true)
      content_type.save
      content_type.publish
    end
  end

  def down
    with_space do |space|
      content_type = space.content_types.find('page')
      field = content_type.fields.detect { |f| f.id == 'permalink' }
      field.omitted = true
      field.disabled = true
      content_type.save
      content_type.fields.destroy('permalink')
      content_type.save
      content_type.publish
    end
  end

end
