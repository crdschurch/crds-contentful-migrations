class AddSoundcloudUrlToSongs < ContentfulMigrations::Migration
  include MigrationUtils

  def up
    with_space do |space|
      content_type = space.content_types.find('song')
      content_type.fields.create(id: 'soundcloud_url', name: 'Soundcloud URL', type: 'Symbol')
      content_type.save
      content_type.publish
    end
  end

  def down
    with_space do |space|
      content_type = space.content_types.find('song')

      field = content_type.fields.detect { |f| f.id == 'soundcloud_url' }
      field.omitted = true
      field.disabled = true

      content_type.save
      content_type.activate
      content_type.fields.destroy('soundcloud_url')
    end
  end
end