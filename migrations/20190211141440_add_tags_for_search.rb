class AddTagsForSearch < ContentfulMigrations::Migration

  include MigrationUtils
  TYPES = %w(album author category location page podcast promo series system_page);

  def up
    with_space do |space|
      TYPES.each do |type|
        content_type = space.content_types.find(type)
        content_type.fields.create(id: 'tags', name: 'Tags', type: 'Array', items: items_of_type('Entry', 'tag'))
        content_type.save
        content_type.publish
      end 
    end
  end

  def down
    with_space do |space|
        TYPES.each do |type|
        content_type = space.content_types.find(type)
        field = content_type.fields.detect { |f| f.id == 'tags' }
        field.omitted = true
        field.disabled = true
        content_type.save
        content_type.fields.destroy('tags')
        content_type.save
        content_type.publish
      end
    end
  end

end
