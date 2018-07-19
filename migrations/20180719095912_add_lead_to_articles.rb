class AddLeadToArticles < ContentfulMigrations::Migration
  include MigrationUtils

  def up
    with_space do |space|
      content_type = space.content_types.find('article')
      content_type.fields.create(id: 'lead_text', name: 'Lead Text', type: 'Symbol')
      content_type.save
      content_type.publish
    end
  end

  def down
    with_space do |space|
      content_type = space.content_types.find('article')

      field = content_type.fields.detect { |f| f.id == 'lead_text' }
      field.omitted = true
      field.disabled = true

      content_type.save
      content_type.activate
      content_type.fields.destroy('lead_text')
    end
  end
end