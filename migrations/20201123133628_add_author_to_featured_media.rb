class AddAuthorToFeaturedMedia < ContentfulMigrations::Migration
  def up
    with_space do |space|
      content_type = space.content_types.find('featured_media')

      featureable_content_types = %w{album article author episode message podcast series song video}

      content_type.editField(id: 'entries', name: 'Entries', type: 'Array', items: items_of_type('Entry', featureable_content_types))

      content_type.save
      content_type.publish   
    end
  end

  def down
    with_space do |space|
      content_type = space.content_types.find('featured_media')

      featureable_content_types = %w{album article episode message podcast series song video}

      content_type.editField(id: 'entries', name: 'Entries', type: 'Array', items: items_of_type('Entry', featureable_content_types))

      content_type.save
      content_type.publish
    end
  end
end
