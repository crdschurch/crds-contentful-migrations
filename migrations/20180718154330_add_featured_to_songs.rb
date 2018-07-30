class AddFeaturedToSongs < ContentfulMigrations::Migration
  include MigrationUtils

  def up
    with_space do |space|
      content_type = space.content_types.find('song')
      content_type.fields.create(id: 'call_to_action', name: 'Call To Action', type: 'Symbol')
      content_type.fields.create(id: 'featured_subtitle', name: 'Featured Subtitle', type: 'Symbol')
      content_type.fields.create(id: 'featured_label', name: 'Featured Label', type: 'Symbol')
      content_type.save
      content_type.publish
    end
  end

  def down
    with_space do |space|
      content_type = space.content_types.find('song')

      fields = content_type.fields.select { |f| %w{call_to_action featured_subtitle featured_label}.include?(f.id) }
      fields.each do |field|
        field.omitted = true
        field.disabled = true
      end

      content_type.save
      content_type.publish

      content_type.fields.destroy('call_to_action')
      content_type.fields.destroy('featured_subtitle')
      content_type.fields.destroy('featured_label')

      content_type.save
      content_type.publish
    end
  end
end
