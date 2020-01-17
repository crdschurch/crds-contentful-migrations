class AddSocialLinksToAuthors < ContentfulMigrations::Migration

  include MigrationUtils

  def up
    with_space do |space|
      content_type = space.content_types.find('author')
      content_type.fields.create(id: 'instagram_link', name: 'Instagram Link', type: 'Symbol')
      content_type.fields.create(id: 'facebook_link', name: 'Facebook Link', type: 'Symbol')
      content_type.fields.create(id: 'twitter_link', name: 'Twitter Link', type: 'Symbol')
      content_type.fields.create(id: 'youtube_link', name: 'Youtube Link', type: 'Symbol')

      content_type.save
      content_type.publish
    end
  end
end
