class AddTagsToCategories < ContentfulMigrations::Migration

  include MigrationUtils

  def up
    with_space do |space|
      content_type = space.content_types.find('category')
      content_type.fields.create(id: 'tags', name: 'Featured Tags', type: 'Array', items: items_of_type('Entry', ['tag']))
      content_type.save
      content_type.publish
    end
  end

  def down
    with_space do |space|
      content_type = space.content_types.find('category')
      field = content_type.fields.detect { |f| f.id == 'tags' }
      field.omitted = true
      field.disabled = true
      content_type.save
      content_type.fields.destroy('tags')
      content_type.save
      content_type.publish
    end
  end

end
