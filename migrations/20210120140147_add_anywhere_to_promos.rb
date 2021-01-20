class AddAnywhereToPromos < ContentfulMigrations::Migration
  include MigrationUtils
  def up
    with_space do |space|
      content_type = space.content_types.find('promo')
      field = content_type.fields.detect { |f| f.id == 'target_audience' }
      validations = field.items.validations.first.in
      new_option = 'Anywhere'
      validations.push(new_option)

      content_type.save
      content_type.publish
    end
  end

  def down
    with_space do |space|
      content_type = space.content_types.find('promo')
      field = content_type.fields.detect { |f| f.id == 'target_audience' }
      validations = field.items.validations.first.in
      validations.pop

      content_type.save
      content_type.publish
    end
  end
end
