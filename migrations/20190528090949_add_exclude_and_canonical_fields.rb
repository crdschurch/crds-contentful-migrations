require 'contentful/management/client_editor_interface_methods_factory'

class AddExcludeAndCanonicalFields < ContentfulMigrations::Migration
  include MigrationUtils

  def up
    with_space do |space|
      %w(article video).each do |cid|
        content_type = space.content_types.find(cid)

        content_type.fields.create(id: 'exclude_from_crossroads', name: 'Exclude from crossroads.net?', type: 'Boolean')
        validation_for_type = Contentful::Management::Validation.new
        validation_for_type.in = ['crossroads.net', 'briantome.com']
        content_type.fields.create(id: 'canonical_host', name: 'Canonical Host', type: 'Symbol', validations: [validation_for_type])
        content_type.save
        content_type.publish

        editor_interface = content_type.editor_interface.default
        controls = editor_interface.controls
        controls.detect { |e| e['fieldId'] == 'canonical_host' }['widgetId'] = "dropdown"
        editor_interface.update(controls: controls)
        editor_interface.reload

        content_type.save
        content_type.publish
      end
    end
  end

  def down
    with_space do |space|
      with_space do |space|
        %w(article video).each do |cid|
          content_type = space.content_types.find(cid)
          %w(exclude_from_crossroads canonical_host).each do |id|
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
  end
end
