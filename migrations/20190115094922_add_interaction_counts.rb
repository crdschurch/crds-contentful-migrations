class AddInteractionCounts < ContentfulMigrations::Migration
  include MigrationUtils

  def content_types
    @content_types ||= %w(album article author episode message podcast series song video)
  end

  def up
    with_space do |space|
      content_types.each do |id|
        content_type = space.content_types.find(id)
        content_type.fields.create(id: 'interaction_count', name: 'Interaction Count', type: 'Number', disabled: true)
        content_type.save
        content_type.publish
      end
    end
  end

  def down
    with_space do |space|
      content_types.each do |id|
        content_type = space.content_types.find(id)
        field = content_type.fields.detect { |f| f.id == 'interaction_count' }
        field.omitted = true
        field.disabled = true

        content_type.save
        content_type.activate
        content_type.fields.destroy('interaction_count')
        content_type.save
        content_type.publish
      end
    end
  end
end