require 'contentful/management/client_editor_interface_methods_factory'

class AddSnailTrail < ContentfulMigrations::Migration
  include MigrationUtils

  def up
    with_space do |space|

        ## Create Content model
        content_type = space.content_types.find('page')
        
        ## Create validation
        validation_for_type = Contentful::Management::Validation.new
        validation_for_type.in = ['connect', 'media', 'trending', 'get-connected']
        content_type.fields.create(id: 'snail_trail', name: 'Snail Trail', type: 'Symbol', validations: [validation_for_type])
        
        ## Publish
        content_type.save
        content_type.publish

        ## Editor interface configuration
        editor_interface = content_type.editor_interface.default
        controls = editor_interface.controls
        field = controls.detect { |e| e['fieldId'] == 'snail_trail' }
        field['widgetId'] = "dropdown"
        field['settings'] = { 'helpText' => 'If blank, validation will default to trending' }
        editor_interface.update(controls: controls)
        editor_interface.reload

        content_type.save
        content_type.publish
    end
  end

  def down
    with_space do |space|
          %w(snail_trail).each do |id|
            content_type = space.content_types.find('page')
            field = content_type.fields.detect { |f| f.id == id }
            field.omitted = true
            field.disabled = true
            content_type.save
            content_type.activate
            content_type.fields.destroy(id)
          end
        end
    end
end