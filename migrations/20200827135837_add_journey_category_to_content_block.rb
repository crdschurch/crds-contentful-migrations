class AddJourneyCategoryToContentBlock < ContentfulMigrations::Migration
  include MigrationUtils

  def up
    with_space do |space|
      content_type = space.content_types.find('content_block')
      field = content_type.fields.detect { |f| f.id =='category'}
      validations = field.validations.first.in
      journey = 'journey'
      validations.push(journey)

      content_type.save
      content_type.publish
    end
  end

  def down
    with_space do |space|
      content_type = space.content_types.find('content_block')
      field = content_type.fields.detect { |f| f.id =='category'}
      validations = field.validations.first.in
      journey = 'journey'
      validations.delete_at(validations.index(marketing_series))

      content_type.save
      content_type.publish
    end
  end
end
