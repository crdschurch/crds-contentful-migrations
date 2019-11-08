class MakeMapurlRequired < ContentfulMigrations::Migration
  def up
    with_space do |space|
      content_type = space.content_types.find('location')

      field = content_type.fields.detect { |f| f.id === 'map_image' }
      field.required = true
     
      content_type.save
      content_type.publish
    end
  end

  def down
    with_space do |space|
      content_type = space.content_types.find('location')

      field = content_type.fields.detect { |f| f.id === 'map_image' }
      field.required = false
     
      content_type.save
      content_type.publish
    end
  end
end
