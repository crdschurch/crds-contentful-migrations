class AddImageLinkToSearchWidget < ContentfulMigrations::Migration
  include MigrationUtils

  def up
    with_space do |space|
      content_type = space.content_types.find('search_widget')
      field = content_type.fields.detect { |f| f.id == 'image' }
      field.name = 'Image'
      field.type = 'Link'
      field.link_type = 'Asset'

      content_type.save
      content_type.publish
    end
  end

  def down
    with_space do |space|
      content_type = space.content_types.find('search_widget')

      field = content_type.fields.detect { |f| f.id == 'image' }
      field.name = 'Image URL'
      field.type = 'Symbol'

      content_type.save
      content_type.publish
    end
  end
end
