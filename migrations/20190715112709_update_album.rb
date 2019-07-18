class UpdateAlbum < ContentfulMigrations::Migration

  include MigrationUtils

  def up
    with_space do |space|

      content_type = space.content_types.find('album')

      # Delete Fields
      fields = ['description', 'author']
      fields.each do |field|

        field = content_type.fields.detect { |f| f.id == field }
        next unless
        field.omitted = true
        field.disabled = true

      end

      content_type.save
      content_type.publish

      fields.each do |field|
        content_type.fields.destroy(field)
      end

      # Create Fields
      content_type.fields.create(id: 'behind_the_scenes', name: 'Behind the scenes', type: 'Text')
      content_type.fields.create(id: 'songs', name: 'Songs', type: 'Array', items: items_of_type('Entry', 'song'))
      content_type.fields.create(id: 'featured_videos', name: 'featured_videos', type: 'Array', items: items_of_type('Entry', 'video'))

      content_type.save
      content_type.publish

    end
  end

  def down 

    with_space do |space|

      content_type = space.content_types.find('album')

      # Delete Fields
      fields = ['behind_the_scenes', 'songs', 'featured_videos']
      fields.each do |field|

        field = content_type.fields.detect { |f| f.id == field }
        next unless
        field.omitted = true
        field.disabled = true

      end

      content_type.save
      content_type.publish

      fields.each do |field|
        content_type.fields.destroy(field)
      end

      # Create fields
      content_type.fields.create(id: 'description', name: 'Description', type: 'Text')
      content_type.fields.create(id: 'author', name: 'Author', type: 'Link', link_type: 'Entry', required: true, validations: [validation_of_type('author')])

      content_type.save
      content_type.publish
    end 
  end
end
