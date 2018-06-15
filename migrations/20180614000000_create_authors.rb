require_relative '../lib/migration_utils'

class CreateAuthors < ContentfulMigrations::Migration
  include MigrationUtils

  def initialize(name = self.class.name, version = nil, client = nil, space = nil)
    @type = 'author'
    super(name, version, client, space)
  end

  def up
    with_space do |space|
      content_type = space.content_types.create(
        name: 'Author',
        id: @type,
        description: 'Person associated with one or more pieces of content'
      )

      content_type.fields.create(id: 'full_name', name: 'Full Name', type: 'Symbol', required: true)
      content_type.fields.create(id: 'slug', name: 'Slug', type: 'Symbol', required: true, validations: [uniqueness_of])
      content_type.fields.create(id: 'summary', name: 'Summary', type: 'Text', required: true)
      content_type.fields.create(id: 'image', name: 'Image', type: 'Link', link_type: 'Asset', required: true)

      content_type.save
      content_type.publish
      apply_editor(space, 'slug', 'slugEditor')
    end
  end

end