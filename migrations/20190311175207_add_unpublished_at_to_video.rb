class AddUnpublishedAtToVideo < ContentfulMigrations::Migration

    include MigrationUtils
    def up
      with_space do |space|
        content_type = space.content_types.find('video')
        content_type.fields.create(id: 'unpublished_at', name: 'Unpublished At', type: 'Date')
        content_type.save
        content_type.publish
      end
    end
  end
  