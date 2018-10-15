class AddAuthenticationToPages < ContentfulMigrations::Migration

  include MigrationUtils

  def up
    with_space do |space|
      content_type = space.content_types.find('page')
      
      content_type.fields.create(id: 'requires_auth', name: 'Requires Authentication?', type: 'Boolean')

      content_type.save
      content_type.publish
    end
  end

  def down
    with_space do |space|
      content_type = space.content_types.find('page')
      field = content_type.fields.detect { |f| f.id == 'requires_auth' }
      field.omitted = true
      field.disabled = true

      content_type.save
      content_type.activate
      content_type.fields.destroy('requires_auth')
    end
  end

end
