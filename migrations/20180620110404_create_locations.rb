class CreateLocations < RevertableMigration

  self.content_type_id = 'location'

  def up
    with_space do |space|
      content_type = space.content_types.create(
        name: 'Location',
        id: content_type_id,
        description: 'Models the general geographic area or specific physical orientation of a Crossroads community'
      )
      content_type.fields.create(id: 'name', name: 'Name', type: 'Symbol', required: true)
      content_type.fields.create(id: 'image', name: 'Image', type: 'Link', link_type: 'Asset', required: true)
      content_type.fields.create(id: 'slug', name: 'Slug', type: 'Symbol', required: true, validations: [uniqueness_of])
      content_type.fields.create(id: 'details', name: 'Details', type: 'Text', required: true) # markup/down block for address, service times, etc

      validation_in = Contentful::Management::Validation.new
      validation_in.in = ['default']
      content_type.fields.create(id: 'layout', name: 'Layout', type: 'Symbol', required: true, validations: [validation_in])

      items = Contentful::Management::Field.new
      items.type = 'Symbol'
      content_type.fields.create(id: 'tags', name: 'Tags', type: 'Array', items: items)

      content_type.save
      content_type.publish
      apply_editor(space, 'slug', 'slugEditor')
    end
  end
end