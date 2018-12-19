class RemoveTagsFromPages < ContentfulMigrations::Migration
  def up
    with_space do |space|
      content_type = space.content_types.find('page')

      meta_image = content_type.fields.detect { |f| f.id == 'tags' }
      meta_image.omitted = true
      meta_image.disabled = true
      

      content_type.save
      content_type.activate
      content_type.fields.destroy('tags')
      content_type.save
    end
  end
end
