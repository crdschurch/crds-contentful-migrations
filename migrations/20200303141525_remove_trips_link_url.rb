class RemoveTripsLinkUrl < ContentfulMigrations::Migration

  include MigrationUtils

  def up
    with_space do |space|
      content_type = space.content_types.find('trip')

      field = content_type.fields.detect { |f| f.id == 'link_url'}
      field.omitted = true
      field.disabled = true
      
      content_type.save
      content_type.activate
      content_type.fields.destroy('link_url')
    end
  end
end
