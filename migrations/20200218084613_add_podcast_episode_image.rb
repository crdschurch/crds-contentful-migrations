class AddPodcastEpisodeImage < ContentfulMigrations::Migration
  def up
    with_space do |space|
      content_type = space.content_types.find('episode')
      content_type.fields.create(id: 'image', name: 'Image', type: 'Link', link_type: 'Asset')
      content_type.save
      content_type.publish
    end
  end

  def down
    with_space do |space|
      content_type = space.content_types.find('episode')

      field = content_type.fields.detect { |f| f.id == 'image' }
      field.omitted = true
      field.disabled = true

      content_type.save
      content_type.activate
      content_type.fields.destroy('image')
      content_type.save
      content_type.publish
    end
  end
end
