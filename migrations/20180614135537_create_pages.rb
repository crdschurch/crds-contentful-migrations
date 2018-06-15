require_relative '../lib/migration_utils'

class CreatePages < ContentfulMigrations::Migration
  include MigrationUtils

  def initialize(name = self.class.name, version = nil, client = nil, space = nil)
    @type = 'page'
    super(name, version, client, space)
  end

  def up
    with_space do |space|
      content_type = space.content_types.create(
        name: 'Page',
        id: @type,
        description: 'A piece of content distinguished by a unique path'
      )
      content_type.fields.create(id: 'title', name: 'title', type: 'Symbol', required: true)
      content_type.fields.create(id: 'body', name: 'body', type: 'Text')
      content_type.fields.create(id: 'slug', name: 'slug', type: 'Symbol', required: true, validations: [uniqueness_of])
      content_type.save
      content_type.publish
      apply_editor(space, 'slug', 'slugEditor')
    end
  end

end