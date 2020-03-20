class AddFeaturedImageForPodcasts < ContentfulMigrations::Migration
  def up
    with_space do |space|
      content_type = space.content_types.find('podcast')
      content_type.fields.create(id: 'featured_image', name: 'Featured Image', type: 'Link', link_type: 'Asset')
      content_type.save
      content_type.publish
    end
  end

  def down
    with_space do |space|
      content_type = space.content_types.find('podcast')

      field = content_type.fields.detect { |f| f.id == 'featured_image' }
      field.omitted = true
      field.disabled = true

      content_type.save
      content_type.activate
      content_type.fields.destroy('featured_image')
      content_type.save
      content_type.publish
    end
  end
end
