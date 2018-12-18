class RemoveMetaFromPages < ContentfulMigrations::Migration
  def up
    with_space do |space|
      content_type = space.content_types.find('page')

      meta_image = content_type.fields.detect { |f| f.id == 'meta_image' }
      meta_image.omitted = true
      meta_image.disabled = true
      
      meta_description = content_type.fields.detect { |f| f.id == 'meta_description' }
      meta_description.omitted = true
      meta_description.disabled = true

      content_type.save
      content_type.activate
      content_type.fields.destroy('meta_image')
      content_type.fields.destroy('meta_description')
      content_type.save
    end
  end
end
