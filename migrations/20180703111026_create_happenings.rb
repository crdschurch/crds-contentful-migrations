class CreateHappenings < RevertableMigration

  self.content_type_id = 'happening'

  def up
    with_space do |space|
      content_type = space.content_types.create(
        name: 'Happening',
        id: content_type_id,
        description: 'Models something to be highlighted either at a specific site or in the greater Crossroads community'
      )
      validation_for_relevant_locations = Contentful::Management::Validation.new
      validation_for_relevant_locations.in = ['Churchwide','Oakley','Mason','West Side','East Side','Florence','Dayton','Oxford','Uptown','Columbus','Andover','Georgetown','Richmond']
      validation_for_layout = Contentful::Management::Validation.new
      validation_for_layout.in = ['default']

      content_type.fields.create(id: 'name', name: 'Name', type: 'Symbol', required: true)
      content_type.fields.create(id: 'description', name: 'Description', type: 'Text', required: true) # block of text describing the location
      content_type.fields.create(id: 'image', name: 'Image', type: 'Link', link_type: 'Asset', required: true)
      content_type.fields.create(id: 'happening_url', name: 'Happening Url', type: 'Text', required: true)
      content_type.fields.create(id: 'relevant_locations', name: 'Relevant Locations', type: 'Array', required: true, validations: [validation_for_relevant_locations])
      content_type.fields.create(id: 'layout', name: 'Layout', type: 'Symbol', required: true, validations: [validation_for_layout])

      items = Contentful::Management::Field.new
      items.type = 'Symbol'
      content_type.fields.create(id: 'tags', name: 'Tags', type: 'Array', items: items)

      content_type.save
      content_type.publish
    end
  end
end