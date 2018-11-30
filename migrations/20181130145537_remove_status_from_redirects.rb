class RemoveStatusFromRedirects < ContentfulMigrations::Migration

  include MigrationUtils

  def up
    with_space do |space|
      content_type = space.content_types.find('redirect')
      field = content_type.fields.detect { |f| f.id == 'status' }
      
      field.omitted = true
      field.disabled = true
    
      content_type.save
      content_type.fields.destroy(field)
      content_type.save
      content_type.publish
    end
  end
end
