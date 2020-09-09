class AddPublisherToAlbums < ContentfulMigrations::Migration
  def up
    with_space do |space|
      content_type = space.content_types.find('album')
      content_type.fields.create(id: 'publisher', name: 'Publisher', type: 'Text')
      content_type.save
      content_type.publish
    end
  end

  def down
    with_space do |space|
      content_type = space.content_types.find('album')
      field = content_type.fields.detect { |f| f.id == 'publisher' }
      field.omitted = true
      field.disabled = true
      content_type.save
      content_type.activate 
      content_type.fields.destroy('publisher')
      content_type.save
    end
  end
end
