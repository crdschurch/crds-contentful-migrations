class NormalizeDurations < ContentfulMigrations::Migration

  include MigrationUtils
  TYPES = %w(article video song episode message)

  def up
    with_space do |space|
      TYPES.each do |type|
        content_type = space.content_types.find(type)
        content_type.fields.create(id: 'duration', name: 'Duration (seconds)', type: 'Number', disabled: true)
        content_type.save
        content_type.publish
      end
    end
  end

  def down
    with_space do |space|
      TYPES.each do |type|
        content_type = space.content_types.find(type)
        field = content_type.fields.detect { |f| f.id == 'duration' }
        field.omitted = true
        field.disabled = true
        content_type.save
        content_type.fields.destroy('duration')
        content_type.save
        content_type.publish
      end
    end
  end

end