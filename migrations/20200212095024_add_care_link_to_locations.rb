class AddCareLinkToLocations < ContentfulMigrations::Migration

  include MigrationUtils

  def up
    with_space do |space|
      content_type = space.content_types.find('location')
      content_type.fields.create(id: 'care_link', name: 'Care Link', type: 'Symbol')
      content_type.save
      content_type.publish
    end
  end
end
