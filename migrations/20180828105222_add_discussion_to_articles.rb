class AddDiscussionToArticles < ContentfulMigrations::Migration
  include MigrationUtils

  def up
    with_space do |space|
      content_type = space.content_types.find('article')
      content_type.fields.create(id: 'discussion', name: 'Discussion', type: 'Link', link_type: 'Entry', validations: [validation_of_type('discussion')])
      content_type.save
      content_type.publish
    end
  end

  def down
    with_space do |space|
      content_type = space.content_types.find('article')

      field = content_type.fields.detect { |f| f.id == 'discussion' }
      field.omitted = true
      field.disabled = true

      content_type.save
      content_type.activate
      content_type.fields.destroy('discussion')
    end
  end
end
