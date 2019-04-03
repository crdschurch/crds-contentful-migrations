class AddSlugToCollections < ContentfulMigrations::Migration
  include MigrationUtils
  def up
    with_space do |space|
      content_type = space.content_types.find('collection')
      content_type.fields.create(id: 'slug', name: 'Slug', type: 'Symbol', required: true, validations: [uniqueness_of])

      content_type.save
      content_type.publish
    end
  end

  def down
    with_space do |space|
      content_type = space.content_types.find('collection')

      field = content_type.fields.detect { |f| f.id == 'slug' }
      field.omitted = true
      field.disabled = true

      content_type.save
      content_type.activate
      content_type.fields.destroy('slug')
    end
  end
end
