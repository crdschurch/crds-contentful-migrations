class AddArtistToSong < ContentfulMigrations::Migration
  def up
    with_space do |space|
      content_type = space.content_types.find('song')
      content_type.fields.create(id: 'artist', name: 'Artist', type: 'Text')
      content_type.save
      content_type.publish
    end
  end
  def down
    with_space do |space|
      content_type = space.content_types.find('song')
      field = content_type.fields.detect { |f| f.id == 'artist' }
      field.omitted = true
      field.disabled = true
      content_type.save
      content_type.publish
    end
  end
end