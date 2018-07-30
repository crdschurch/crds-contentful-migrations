require 'pry'

class AddVideoCollectionToTags < ContentfulMigrations::Migration

  def up
    with_space do |space|
      content_type = space.content_types.find('tag')

      content_type.fields.create(id: 'video_collection', name: 'Video Collection?', type: 'Boolean')

      content_type.save
      content_type.publish
    end
  end

  def down
    with_space do |space|
      content_type = space.content_types.find('tag')

      field = content_type.fields.detect { |f| f.id == 'video_collection' }
      field.omitted = true
      field.disabled = true

      content_type.save
      content_type.publish

      content_type.fields.destroy('video_collection')

      content_type.save
      content_type.publish
    end
  end

end
