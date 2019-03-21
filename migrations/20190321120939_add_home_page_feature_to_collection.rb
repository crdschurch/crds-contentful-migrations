class AddHomePageFeatureToCollection < ContentfulMigrations::Migration
  def up
    with_space do |space|
      content_type = space.content_types.find('collection')
      content_type.fields.create(id: 'featured_on_home', name: 'Featured on Home Page', type: 'Boolean')
      content_type.save
      content_type.publish
    end
  end

  def down
    with_space do |space|
      content_type = space.content_types.find('collection')

      field = content_type.fields.detect { |f| f.id == 'featured_on_home' }
      field.omitted = true
      field.disabled = true

      content_type.save
      content_type.activate
      content_type.fields.destroy('featured_on_home')
    end
  end
end
