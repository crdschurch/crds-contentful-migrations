class AddAudioToMessages < ContentfulMigrations::Migration
  include MigrationUtils

  def up
    with_space do |space|
      content_type = space.content_types.find('message')

      content_type.fields.create(id: 'audio_source_url', name: 'Audio Source URL', type: 'Symbol')
      destroy_field('source_link', content_type)
      content_type.fields.create(id: 'source_url', name: 'Video Source URL', type: 'Symbol')

      content_type.save
      content_type.publish
    end
  end

  def down
    with_space do |space|
      content_type = space.content_types.find('message')
      destroy_field('audio_source_url', content_type)
      destroy_field('source_url', content_type)
      content_type.fields.create(id: 'source_link', name: 'Source URL', type: 'Symbol')
    end
  end

  private

    def destroy_field(name, content_type)
      field = content_type.fields.detect { |f| f.id == name }
      return if field.nil?
      field.omitted = true
      field.disabled = true

      content_type.save
      content_type.activate
      content_type.fields.destroy(name)
    end

end