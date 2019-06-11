class AddBitmovinVideoSong < ContentfulMigrations::Migration
  include MigrationUtils

  def up
    with_space do |space|
      models = ['song','video']
      
      models.each do |model|
        content_type = space.content_types.find(model)

        content_type.fields.create(id: 'video_file', name: 'Video File', type: 'Link', link_type: 'Asset', validations: [require_mime_type(:video)])
        content_type.fields.create(id: 'bitmovin_url', name: 'Bitmovin Url', type: 'Symbol')

        content_type.save
        content_type.publish
      end

    end
  end

  def down
    with_space do |space|

      models = ['song','video']
      models.each do |model|
        content_type = space.content_types.find(model)

        video_file = content_type.fields.detect { |f| f.id == 'video_file' }
        video_file.omitted = true
        video_file.disabled = true

        bitmovin_url = content_type.fields.detect { |f| f.id == 'bitmovin_url' }
        bitmovin_url.omitted = true
        bitmovin_url.disabled = true

        content_type.save
        content_type.activate
        content_type.fields.destroy('video_file')
        content_type.fields.destroy('bitmovin_url')
      end

    end
  end

end
