require_relative '../lib/migration_utils'

class CreateMessages < ContentfulMigrations::Migration
  include MigrationUtils

  def initialize(name = self.class.name, version = nil, client = nil, space = nil)
    @type = 'message'
    super(name, version, client, space)
  end

  def up
    with_space do |space|

      content_type.fields.create(id: 'series', name: 'Series', type: 'Link', link_type: 'Entry', required: true, validations: [validation_of_type('series')])

      content_type.save
      content_type.publish
      apply_editor(space, 'slug', 'slugEditor')
    end
  end

end