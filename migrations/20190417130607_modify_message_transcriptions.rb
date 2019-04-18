class ModifyMessageTranscriptions < ContentfulMigrations::Migration

  include MigrationUtils

  def up
    with_space do |space|
      content_type = space.content_types.find('message')

      content_type.fields.destroy('transcription')
      content_type.save
      content_type.publish
      content_type.fields.create(id: 'transcription', name: 'Transcription', type: 'Link', link_type: 'Asset')
      content_type.save
      content_type.publish
    end
  end

  def down
    with_space do |space|
      # content_type = space.content_types.find('message')
      # content_type.fields.destroy('transcription')
      # content_type.fields.create(id: 'transcription', name: 'Transcription', type: 'Text')
      # content_type.save
      # content_type.publish
    end
  end
end
