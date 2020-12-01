class AddAuthorAndTagsToFeaturedMedia < ContentfulMigrations::Migration

  include MigrationUtils

  def up
    with_space do |space|
      content_type = space.content_types.find('featured_media')

      featureable_content_types = %w{album article author episode message podcast series song tag video}
      field = content_type.fields.detect{|f| f.id == 'entries'}
      field.items = items_of_type('Entry', featureable_content_types)

      content_type.save
      content_type.publish
    end
  end

  def down
    with_space do |space|
      content_type = space.content_types.find('featured_media')

      featureable_content_types = %w{album article episode message podcast series song video}
      field = content_type.fields.detect{|f| f.id == 'entries'}
      field.items = items_of_type('Entry', featureable_content_types)

      content_type.save
      content_type.publish
    end
  end
end
