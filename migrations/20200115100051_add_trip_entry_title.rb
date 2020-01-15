class AddTripEntryTitle < ContentfulMigrations::Migration

  include MigrationUtils

  def up
    with_space do |space|
      content_type = space.content_types.find('trip')
      content_type.update(displayField: 'country')

      content_type.save
      content_type.publish
    end
  end
end
