class AddSpnSubsToMessage < ContentfulMigrations::Migration
  def up
    with_space do |space|
      content_type = space.content_types.find('message')
      content_type.fields.create(id: 'spn_transcription', name: 'Spanish Transcription', type: 'Link', link_type: 'Asset')
    end
  end

  def down
    with_space do |space|
      content_type = space.content_types.find('message')

      transcription = content_type.fields.detect { |f| f.id == 'spn_transcription' }
      transcription.omitted = true
      transcription.disabled = true

      content_type.save
      content_type.activate
      content_type.fields.destroy('spn_transcription')
    end
  end
end
