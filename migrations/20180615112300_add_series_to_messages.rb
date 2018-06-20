require_relative '../lib/migration_utils'

class UpdateMessages < ContentfulMigrations::Migration
  include MigrationUtils

  def up
    with_space do |space|
      content_type = space.content_types.find('message')
      content_type.fields.create(id: 'series', name: 'Series', type: 'Link', link_type: 'Entry', required: true, validations: [validation_of_type('series')])
      content_type.save
      content_type.publish
    end
  end

  def down
    with_space do |space|
      content_type = space.content_types.find('message')

      field = content_type.fields.detect { |f| f.id == 'series' }
      field.omitted = true
      field.disabled = true

      content_type.save
      content_type.activate
      content_type.fields.destroy('series')
    end
  end
end