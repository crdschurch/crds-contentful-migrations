class AddWatchSectionToPromo < ContentfulMigrations::Migration

  include MigrationUtils

  def up
    with_space do |space|
      content_type = space.content_types.find('promo')
      field = content_type.fields.detect { |f| f.id =='section'}
      validations = field.items.validations.first.in
      watch_page = 'Watch Page'
      validations.push(watch_page)

      content_type.save
      content_type.publish
    end
  end

  def down
    with_space do |space|
      content_type = space.content_types.find('promo')
      field = content_type.fields.detect { |f| f.id =='section'}
      validations = field.items.validations.first.in
      watch_page = 'Watch Page'
      validations.delete_at(validations.index(watch_page))

      content_type.save
      content_type.publish
    end
  end
end
