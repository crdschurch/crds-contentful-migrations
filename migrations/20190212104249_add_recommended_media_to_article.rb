class AddRecommendedMediaToArticle < ContentfulMigrations::Migration

  include MigrationUtils

  # /Users/jeff/.rbenv/versions/2.4.3/lib/ruby/gems/2.4.0/gems/contentful-management-2.6.0/lib/contentful/management
  def up
    with_space do |space|
      content_type = space.content_types.find('article')
      content_type.fields.create(id: 'recommended_media', name: 'Recommended Media', type: 'Link', link_type: 'Entry', validations: [validation_of_type(%w(article episode message song podcast series video))])
      content_type.fields.create(id: 'sign_off', name: 'Sign Off', type: 'Link', link_type: 'Entry', validations: [validation_of_type('sign_off')])
      content_type.save
      content_type.publish
    end
  end

  def down
    with_space do |space|
      content_type = space.content_types.find('article')

      %w(recommended_media sign_off).each do |field_name|
        field = content_type.fields.detect { |f| f.id == field_name }
        field.omitted = true
        field.disabled = true
      end
      
      content_type.save
      content_type.activate
      
      %w(recommended_media sign_off).each do |field_name|
        content_type.fields.destroy(field_name)
      end
      content_type.save
      content_type.publish
    end
  end
end
