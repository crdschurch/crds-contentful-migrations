class AddUnpublishedAtToPromo < ContentfulMigrations::Migration

    include MigrationUtils
    def up
      with_space do |space|
        content_type = space.content_types.find('promo')
        content_type.fields.create(id: 'unpublished_at', name: 'Unpublished At', type: 'Date')
        content_type.save
        content_type.publish
      end
    end
    def down
        with_space do |space|
            content_type = space.content_types.find('promo')
      
            field = content_type.fields.detect { |f| f.id == 'unpublished_at' }
            field.omitted = true
            field.disabled = true
      
            content_type.save
            content_type.activate
            content_type.fields.destroy('unpublished_at')
          end
      end
  end
  