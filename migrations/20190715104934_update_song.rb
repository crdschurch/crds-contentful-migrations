class UpdateSong < ContentfulMigrations::Migration

  include MigrationUtils

  def up

    with_space do |space|

      content_type = space.content_types.find('song')

      # Delete fields
      fields = [
        'description',
        'details',
        'chords',
        'category',
        'author',
        'audio_duration',
        'album',
        'image',
        'tags',
        'soundcloud_url',
        'call_to_action',
        'featured_subtitle',
        'featured_label',
        'duration',
        'collections'
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

      # Create Fields
      content_type.fields.create(id: 'ccli_number', name: 'CCLI Number', type: 'Symbol')
      content_type.fields.create(id: 'written_by', name: 'Written By', type: 'Symbol')
      content_type.fields.create(id: 'song_select_url', name: 'Song Select Url', type: 'Symbol')
      content_type.fields.create(id: 'video', name: 'Video', type: 'Link', link_type: 'Entry', validations: [validation_of_type('video')])
      content_type.fields.create(id: 'lyrics_file', name: 'Lyrics File', type: 'Link', link_type: 'Asset')
      content_type.fields.create(id: 'chords_file', name: 'Chords File', type: 'Link', link_type: 'Asset')

      # Set required fields
      field = content_type.fields.detect { |f| f.id == 'bg_image' }
      field.required = true

      content_type.save
      content_type.publish
    end
  end

  def down

    with_space do |space|
      
      # Delete fields
      fields = [
        'ccli_number'
        'written_by'
        'song_select_url'
        'video'
        'lyrics_file'
        'chords_file'
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

      items = Contentful::Management::Field.new	
      items.type = 'Symbol'	

      # Create fields
      content_type.fields.create(id: 'description', name: 'Description', type: 'Text')	
      content_type.fields.create(id: 'details', name: 'Details', type: 'Text')	
      content_type.fields.create(id: 'chords', name: 'Chords', type: 'Text')	
      content_type.fields.create(id: 'tags', name: 'Tags', type: 'Array', items: items)	
      content_type.fields.create(id: 'category', name: 'Category', type: 'Link', link_type: 'Entry', validations: [validation_of_type('category')])	
      content_type.fields.create(id: 'author', name: 'Author', type: 'Array', items: items_of_type('Entry', 'author'))	
      content_type.fields.create(id: 'audio_duration', name: 'Audio Duration', type: 'Text')	
      content_type.fields.create(id: 'album', name: 'Album', type: 'Link', link_type: 'Entry', validations: [validation_of_type('author')])	
      content_type.fields.create(id: 'image', name: 'Image', type: 'Link', link_type: 'Asset', required: true)	
      content_type.fields.create(id: 'featured_subtitle', name: 'Featured subtitle', type: 'Symbol')	
      content_type.fields.create(id: 'featured_label', name: 'Featured label', type: 'Symbol')	
      content_type.fields.create(id: 'duration', name: 'duration (seconds)', type: 'Integer')	
      content_type.fields.create(id: 'collections', name: 'Collections', type: 'Link', link_type: 'Entry', validations: [validation_of_type('collection')])
      content_type.fields.create(id: 'soundcloud_url', name: 'YouTube URL', type: 'Symbol')	

      content_type.save
      content_type.publish

    end

  end
end