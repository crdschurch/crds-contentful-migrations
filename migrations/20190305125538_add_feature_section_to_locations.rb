class AddFeatureSectionToLocations < ContentfulMigrations::Migration
  include MigrationUtils

  def up
    with_space do |space|
      content_type = space.content_types.find('location')
      content_type.fields.create(id: 'featured_section', name: 'Featured Section', type: 'Text')
      content_type.save
      content_type.publish
    end
  end

  def down
    with_space do |space|
      content_type = space.content_types.find('location')

      field = content_type.fields.detect { |f| f.id == 'feature_section' }
      field.omitted = true
      field.disabled = true

      content_type.save
      content_type.activate
      content_type.fields.destroy('feature_section')
      content_type.save
      content_type.publish
    end
  end
end
