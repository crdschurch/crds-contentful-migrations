class ReworkSignUpForms < ContentfulMigrations::Migration

    include MigrationUtils
  
    def up
      with_space do |space|
        content_type = space.content_types.find('sign_up_form')
        field = content_type.fields.detect { |f| f.id == 'className' }
        
        field.omitted = true
        field.disabled = true
      
        content_type.save
        content_type.activate
        content_type.fields.destroy(field)
        content_type.save
        content_type.activate
        content_type.publish

        field = content_type.fields.detect { |f| f.id == 'link' }
        field.name = 'slug'
        field.id = 'slug'

        content_type.save
        content_type.activate
        content_type.publish
    end
  end
end
  