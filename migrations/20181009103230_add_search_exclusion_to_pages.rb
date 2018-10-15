class AddSearchExclusionToPages < ContentfulMigrations::Migration

  include MigrationUtils

  def up
    with_space do |space|
      content_type = space.content_types.find('page')
      
      content_type.fields.create(id: 'search_excluded', name: 'Exclude From Search?', type: 'Boolean')

      content_type.save
      content_type.publish
    end
  end

  def down
    with_space do |space|
      content_type = space.content_types.find('page')
      field = content_type.fields.detect { |f| f.id == 'search_excluded' }
      field.omitted = true
      field.disabled = true

      content_type.save
      content_type.activate
      content_type.fields.destroy('search_excluded')
    end
  end

end
