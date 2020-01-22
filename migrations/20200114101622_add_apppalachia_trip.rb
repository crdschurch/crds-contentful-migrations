class AddApppalachiaTrip < ContentfulMigrations::Migration

  include MigrationUtils

  def up
    with_space do |space|
      content_type = space.content_types.find('trip')
      field = content_type.fields.detect { |f| f.id =='country'}
      validations = field.validations.first.in
      new_trip = 'Appalachia'
      validations.unshift(new_trip)

      content_type.save
      content_type.publish
    end
  end
end
