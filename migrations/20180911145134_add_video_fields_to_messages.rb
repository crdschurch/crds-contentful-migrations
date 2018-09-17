class AddVideoFieldsToMessages < ContentfulMigrations::Migration
  include MigrationUtils

  def up
    with_space do |space|
      content_type = space.content_types.find('message')

      content_type.fields.create(id: 'video_file', name: 'Video File', type: 'Link', link_type: 'Asset', validations: [require_mime_type(:video)])
      content_type.fields.create(id: 'audio_file', name: 'Audio File', type: 'Link', link_type: 'Asset', validations: [require_mime_type(:audio)])

      content_type.save
      content_type.publish
    end
  end

  def down
    with_space do |space|
      content_type = space.content_types.find('message')

      field = content_type.fields.detect { |f| f.id == 'video_file' }
      field.omitted = true
      field.disabled = true

      field = content_type.fields.detect { |f| f.id == 'audio_file' }
      field.omitted = true
      field.disabled = true

      content_type.save
      content_type.activate
      content_type.fields.destroy('video_file')
      content_type.fields.destroy('audio_file')
    end
  end

end