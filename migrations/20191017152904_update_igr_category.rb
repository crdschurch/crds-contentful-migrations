class UpdateIgrCategory < ContentfulMigrations::Migration
  include MigrationUtils
  def up
    with_space do |space|

      content_type = space.content_types.find('category')

      field = content_type.fields.detect { |f| f.id == 'description' }
      field.disabled = true
      
      content_type.save
      content_type.publish

      content_type.fields.create(id: 'subtitle', name: 'Subtitle', type: 'Text')
      content_type.fields.create(id: 'body', name: 'body', type: 'Text')
      content_type.fields.create(id: 'collections', name: 'Collections', type: 'Array', items: items_of_type('Entry', 'collection'))

      content_type.fields.create(id: 'exclude_from_crossroads', name: 'Exclude from crossroads.net?', type: 'Boolean')
      validation_for_type = Contentful::Management::Validation.new
      validation_for_type.in = ['www.crossroads.net', 'www.briantome.com']
      content_type.fields.create(id: 'canonical_host', name: 'Canonical Host', type: 'Symbol', validations: [validation_for_type])

      content_type.activate

    end
  end

  def down
    with_space do |space|
      content_type = space.content_types.find('category')

       fields = [
        'subtitle',
        'body',
        'collection',
        'exclude_from_crossroads',
        'canonical_host'
      ]

      fields.each do |field|
        field = content_type.fields.detect { |f| f.id == field }
        next unless field
        field.omitted = true
        field.disabled = true
      end
      
      content_type.save
      content_type.publish
      
      fields.each do |field|
        content_type.fields.destroy(field)
      end

      field = content_type.fields.detect { |f| f.id == 'description' }
      field.disabled_editing = false
      
      content_type.activate
    end
  end
end
