class CreateTrip < RevertableMigration

  self.content_type_id = 'trip'

  def up
    with_space do |space|

      # Create content model
      content_type = space.content_types.create(
        name: 'Trip',
        id: content_type_id,
        description: 'Content model for trip cards'
      )

      # Set validation
      validation_for_country = Contentful::Management::Validation.new
      validation_for_country.in = ['Bolivia','Haiti','India','Nicaragua', 'Puerto Rico', 'South Africa']

      content_type.fields.create(id: 'image', name: 'Image', type: 'Link', link_type: 'Asset', required: true)
      content_type.fields.create(id: 'country', name: 'Country', type: 'Symbol', required: true,  validations: [validation_for_country])
      content_type.fields.create(id: 'trip_details', name: 'Trip Details', type: 'Symbol')
      content_type.fields.create(id: 'start_date', name: 'Start Date', type: 'Date', required: true)
      content_type.fields.create(id: 'end_date', name: 'End Date', type: 'Date', required: true)
      content_type.fields.create(id: 'trip_description', name: 'Trip Description', type: 'Text')
      content_type.fields.create(id: 'link_url', name: 'Link URL', type: 'Symbol', required: true)

      # Publish
      content_type.save
      content_type.publish

      # Editor interface config
      editor_interface = content_type.editor_interface.default
      controls = editor_interface.controls
      field = controls.detect { |e| e['fieldId'] == 'trip_details' }
      field['settings'] = { 'helpText' => 'City, month, participant type, etc.' }
      editor_interface.update(controls: controls)
      editor_interface.reload

      content_type.save
      content_type.publish
    end
  end
end
