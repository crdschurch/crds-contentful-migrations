class RemoveImageInSystemPages < ContentfulMigrations::Migration

  include MigrationUtils
  def up
    with_space do |space|
      content_type = space.content_types.find('system_page')
      field = content_type.fields.detect { |f| f.id == 'image' }
      field.omitted = true
      field.disabled = true
      content_type.save
      content_type.activate
      content_type.fields.destroy('image')
      content_type.save
      content_type.activate
      content_type.publish
    end
  end
end
