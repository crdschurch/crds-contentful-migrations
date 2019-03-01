class AddSlugToContentBlock < ContentfulMigrations::Migration
  def up
    with_space do |space|
      content_type = space.content_types.find('content_block')
      content_type.fields.create(id: 'slug', name: 'Slug', type: 'Symbol', required: true)
      content_type.save
      content_type.publish
    end
  end

  def down
    with_space do |space|
      content_type = space.content_types.find('content_block')

      field = content_type.fields.detect { |f| f.id == 'slug' }
      field.omitted = true
      field.disabled = true

      content_type.save
      content_type.activate
      content_type.fields.destroy('slug')
    end
  end
end


