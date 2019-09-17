class UpdateSong < ContentfulMigrations::Migration
  def up
    with_space do |space|

      content_type = space.content_types.find('song')

       fields = [
        'ccli_number',
        'written_by'
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

      content_type.fields.create(id: 'description', name: 'Description', type: 'Text')

      content_type.activate

    end
  end

  def down
    with_space do |space|
      content_type = space.content_types.find('song')

       fields = [
        'description'
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

      content_type.fields.create(id: 'ccli_number', name: 'CCLI Number', type: 'Symbol')
      content_type.fields.create(id: 'written_by', name: 'Written By', type: 'Symbol')
      
      content_type.activate
    end
  end
end
