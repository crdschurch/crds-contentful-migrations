class AddMetaToGeneratedPages < ContentfulMigrations::Migration

  include MigrationUtils

  def up
    with_space do |space|
      models = ['album','article','author','category','episode','location','message','perspective','perspective_set','podcast','series','song','video']
      models.each do |model|
        sleep 0.25 # Avoid Contentful rate limit
        content_type = space.content_types.find(model)        
        content_type.fields.create(id: 'meta', name: 'Meta', type: 'Link', link_type: 'Entry', validations: [validation_of_type('meta')])
        content_type.save
        content_type.publish
      end
    end
  end

  def down
    with_space do |space|
      models = ['album','article','author','category','episode','location','message','perspective','perspective_set','podcast','series','song','video']
      models.each do |model|
        sleep 0.25 # Avoid Contentful rate limit
        field = content_type.fields.detect { |f| f.id == 'meta' }
        field.omitted = true
        field.disabled = true
  
        content_type.save
        content_type.activate
        content_type.fields.destroy('meta')
      end
    end
  end

end
