class AddsNoneValueToSnailtrail< ContentfulMigrations::Migration

  def up
    with_space do |space|

      content_type = space.content_types.find('page')
      field = content_type.fields.detect { |f| f.id == 'snail_trail' } 
      validations = field.validations.first.in
      new_option = 'disabled'
      validations.push(new_option)

      content_type.save
      content_type.publish

    end
  end

  def down
    with_space do |space|
      content_type = space.content_types.find('page')
      field = content_type.fields.detect { |f| f.id == 'snail_trail' }
      validations = field.validations.first.in
      validations.pop

      content_type.save
      content_type.publish
      end
    end
end
