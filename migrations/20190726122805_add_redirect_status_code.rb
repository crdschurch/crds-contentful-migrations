class AddRedirectStatusCode < ContentfulMigrations::Migration

  include MigrationUtils

  def up
    with_space do |space|

      ## Create Content model
      content_type = space.content_types.find('redirect')

      ## Create validation
      validation_for_type = Contentful::Management::Validation.new
      validation_for_type.in = [200,301,302,401,410]
      content_type.fields.create(id: 'status_code', name: 'Status code', type: 'Integer', validations: [validation_for_type])
      content_type.fields.create(id: 'is_forced', name: 'Is forced', type: 'Boolean')
      
      ## Publish
      content_type.save
      content_type.publish

      ## Editor interface configuration
      editor_interface = content_type.editor_interface.default
      controls = editor_interface.controls
      field = controls.detect { |e| e['fieldId'] == 'status_code' }
      field['widgetId'] = "dropdown"
      field['settings'] = { 'helpText' => 'If blank, validation will default to 302' }

      field = controls.detect { |e| e['fieldId'] == 'is_forced' }
      field['settings'] = { 'helpText' => 'Check if you’re 100% sure that you’ll always want to redirect, even when the URL matches a static file.' }

      editor_interface.update(controls: controls)
      editor_interface.reload

      content_type.save
      content_type.publish

    end
  end

  def down 

    with_space do |space|

      content_type = space.content_types.find('redirect')

      # Delete Fields
      fields = ['status_code','is_forced']
      fields.each do |field|

        field = content_type.fields.detect { |f| f.id == field }
        next unless
        field.omitted = true
        field.disabled = true

      end

      content_type.save
      content_type.publish

      fields.each do |field|
        content_type.fields.destroy(field)
      end

      content_type.save
      content_type.publish
    end 
  end
end
