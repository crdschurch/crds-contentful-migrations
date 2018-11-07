class AddMetaDataToPages < ContentfulMigrations::Migration

  include MigrationUtils

  def up
    with_space do |space|
      content_type = space.content_types.find('page')
      
      content_type.fields.create(id: 'meta', name: 'Meta', type: 'Link', link_type: 'Entry', validations: [validation_of_type('meta')])

      content_type.save
      content_type.publish
    end
  end

  def down
    with_space do |space|
      content_type = space.content_types.find('page')
      field = content_type.fields.detect { |f| f.id == 'meta' }
      field.omitted = true
      field.disabled = true

      content_type.save
      content_type.activate
      content_type.fields.destroy('meta')
    end
  end

end
