class AddVideoTranscript < ContentfulMigrations::Migration
  def up
    with_space do |space|
      content_type = space.content_types.find('video')

      fields = [
        'transcription'
      ]

      fields.each do |field|
        field = content_type.fields.detect { |f| f.id == field }
        next unless field
        field.omitted = true
        field.disabled = true
      end
      
      content_type.save
      content_type.publish
      
      fields.each do |field|
        content_type.fields.destroy(field)
      end

      content_type.fields.create(id: 'transcript', name: 'transcript', type: 'Text')

      content_type.activate 

    end
  end

  def down
    with_space do |space|
      content_type = space.content_types.find('video')

      fields = [
        'transcript'
      ]

      fields.each do |field|
        field = content_type.fields.detect { |f| f.id == field }
        next unless field
        field.omitted = true
        field.disabled = true
      end
      
      content_type.save
      content_type.publish
      
      fields.each do |field|
        content_type.fields.destroy(field)
      end

      content_type.fields.create(id: 'transcription', name: 'Transcription', type: 'Link', link_type: 'Asset')

      content_type.activate 
    end
  end
end
