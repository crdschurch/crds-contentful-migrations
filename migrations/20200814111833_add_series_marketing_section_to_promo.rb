class AddSeriesMarketingSectionToPromo < ContentfulMigrations::Migration

  include MigrationUtils

  def up
    with_space do |space|
      content_type = space.content_types.find('promo')
      field = content_type.fields.detect { |f| f.id =='section'}
      validations = field.items.validations.first.in
      media_series = 'Media Series Page'
      validations.push(media_series)
      marketing_series = 'Marketing Series Page'
      validations.push(marketing_series)

      content_type.save
      content_type.publish
    end
  end

  def down
    with_space do |space|
      content_type = space.content_types.find('promo')
      field = content_type.fields.detect { |f| f.id =='section'}
      validations = field.items.validations.first.in
      marketing_series = 'Marketing Series Page'
      validations.delete_at(validations.index(marketing_series))
      media_series = 'Media Series Page'
      validations.delete_at(validations.index(media_series))

      content_type.save
      content_type.publish
    end
  end
end
