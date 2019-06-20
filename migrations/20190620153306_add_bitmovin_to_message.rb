class AddBitmovinVideo < ContentfulMigrations::Migration
  include MigrationUtils

  def up
    with_space do |space|
      content_type = space.content_types.find('message')

      content_type.fields.create(id: 'video_file', name: 'Video File', type: 'Link', link_type: 'Asset', validations: [require_mime_type(:video)])
      content_type.fields.create(id: 'bitmovin_url', name: 'Bitmovin Url', type: 'Symbol')
      content_type.fields.create(id: 'transcription', name: 'Transcription', type: 'Link', link_type: 'Asset')

      content_type.save
      content_type.publish
    end
  end

  def down
    with_space do |space|
      content_type = space.content_types.find('message')

      video_file = content_type.fields.detect { |f| f.id == 'video_file' }
      video_file.omitted = true
      video_file.disabled = true

      bitmovin_url = content_type.fields.detect { |f| f.id == 'bitmovin_url' }
      bitmovin_url.omitted = true
      bitmovin_url.disabled = true

      transcription = content_type.fields.detect { |f| f.id == 'transcription' }
      transcription.omitted = true
      transcription.disabled = true

      content_type.save
      content_type.activate
      content_type.fields.destroy('video_file')
      content_type.fields.destroy('bitmovin_url')
      content_type.fields.destroy('transcription')
    end
  end

end
