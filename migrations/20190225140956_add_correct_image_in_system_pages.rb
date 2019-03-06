class AddCorrectImageInSystemPages < ContentfulMigrations::Migration

  include MigrationUtils
  def up
    with_space do |space|
      content_type = space.content_types.find('system_page')
      content_type.fields.create(id: 'image', name: 'Image', type: 'Link', link_type: 'Asset', validations: [require_mime_type(:image)])
      content_type.save
      content_type.publish
    end
  end
end
