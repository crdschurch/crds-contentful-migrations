class AddMonetateToPage < ContentfulMigrations::Migration

  include MigrationUtils

  def up
    with_space do |space|
      content_type = space.content_types.find('page')
      content_type.fields.create(id: 'monetate_page_type', name: 'Monetate Page Type', type: 'Symbol')
      content_type.save
      content_type.publish
    end
  end

  def down
    with_space do |space|
      content_type = space.content_types.find('page')

      field = content_type.fields.detect { |f| f.id == 'monetate_page_type' }
      field.omitted = true
      field.disabled = true

      content_type.save
      content_type.activate
      content_type.fields.destroy('monetate_page_type')
    end
  end

end
