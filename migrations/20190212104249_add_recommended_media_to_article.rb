class AddRecommendedMediaToArticle < ContentfulMigrations::Migration

  include MigrationUtils

  # /Users/jeff/.rbenv/versions/2.4.3/lib/ruby/gems/2.4.0/gems/contentful-management-2.6.0/lib/contentful/management
  def up
    with_space do |space|
      content_type = space.content_types.find('article')

      content_type.fields.create(id: 'recommended_media', name: 'Recommended Media', type: 'Link', link_type: 'Entry', required: true, validations: [validation_of_type(%w(article episode message song podcast series video))])
      content_type.save

      validation_size = Contentful::Management::Validation.new
      validation_size.size = { min: 1, max: 1 }

      content_type.publish
    end
  end

  def down
    with_space do |space|
      content_type = space.content_types.find('article')
      field = content_type.fields.detect { |f| f.id == 'recommended_media' }
      field.omitted = true
      field.disabled = true
      content_type.save
      content_type.activate

      content_type.fields.destroy('recommended_media')
      content_type.save
      content_type.publish
    end
  end
end
