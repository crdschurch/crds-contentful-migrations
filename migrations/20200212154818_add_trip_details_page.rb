class AddTripDetailsPage < ContentfulMigrations::Migration

  include MigrationUtils

  def up
    with_space do |space|

      Set validation
      validation_for_restrictions = Contentful::Management::Validation.new
      validation_for_restrictions.in = ['Background Check Required', 'None']

      content_type = space.content_types.find('trip')
      content_type.fields.create(id: 'slug', name: 'Slug', type: 'Symbol', required: true, validations: [uniqueness_of])
      content_type.fields.create(id:'sign_up_link', name: 'Sign Up Link', type: 'Symbol', required: true)
      content_type.fields.create(id: 'signup_deadline', name: 'Signup Deadline', type: 'Date', required: true)
      content_type.fields.create(id: 'deposit', name: 'Deposit', type: 'Symbol', required: true)
      content_type.fields.create(id: 'trip_size', name: 'Trip Size', type: 'Symbol', required: true)
      content_type.fields.create(id: 'minimum_age', name: 'Minimum Age', type: 'Symbol', required: true)
      content_type.fields.create(id: 'restrictions', name: 'Restrictions', type: 'Symbol', required: true, validations: [validation_for_restrictions])
      content_type.fields.create(id: 'total_cost', name: 'Total Cost', type: 'Symbol', required: true)
      content_type.fields.create(id: 'other_requirements', name: 'Other Requirements', type: 'Symbol')
      content_type.fields.create(id: 'longitude', name: 'Longitude', type: 'Number', required: true)
      content_type.fields.create(id: 'latitude', name: 'Latitude', type: 'Number', required: true)
      content_type.fields.create(id: 'faq1_title', name: 'FAQ 1 Title', type: 'Symbol', required: true)
      content_type.fields.create(id: 'faq1_subtitle', name: 'FAQ 1 Subtitle', type: 'Symbol', required: true)
      content_type.fields.create(id: 'faq1', name: 'FAQ 1', type: 'Text', required: true)
      content_type.fields.create(id: 'faq2_title', name: 'FAQ 2 Title', type: 'Symbol', required: true)
      content_type.fields.create(id: 'faq2_subtitle', name: 'FAQ 2 Subtitle', type: 'Symbol', required: true)
      content_type.fields.create(id: 'faq2', name: 'FAQ 2', type: 'Text', required: true)
      content_type.fields.create(id: 'itinerary', name: 'Itinerary', type: 'Array', items: items_of_type('Entry', 'trip_itinerary'))
      content_type.fields.create(id: 'lodging_name', name: 'Lodging Name', type: 'Symbol')
      content_type.fields.create(id: 'lodging_description', name: 'Lodging Description', type: 'Text')
      content_type.fields.create(id: 'lodging_image1', name: 'Lodging Image 1', type: 'Link', link_type: 'Asset')
      content_type.fields.create(id: 'lodging_image2', name: 'Lodging Image 2', type: 'Link', link_type: 'Asset')
      content_type.fields.create(id: 'lodging_image3', name: 'Lodging Image 3', type: 'Link', link_type: 'Asset')
      content_type.fields.create(id: 'partner_name', name: 'Partner Name', type: 'Symbol')
      content_type.fields.create(id: 'partner_description', name: 'Partner Description', type: 'Text')
      content_type.fields.create(id: 'partner_image', name: 'Partner Image', type: 'Link', link_type: 'Asset')
      content_type.fields.create(id: 'partner_website', name: 'Partner Website URL', type: 'Symbol')

      content_type.save
      content_type.publish

      # Editor interface config
      editor_interface = content_type.editor_interface.default
      controls = editor_interface.controls
      
      field['widgetId'] = "datePicker"
      field['settings'] = { 'format' => 'dateonly'}

      field = controls.detect { |e| e['fieldId'] == 'signup_deadline' }
      field['settings'] = { 'format' => 'dateonly'}
      field = controls.detect { |e| e['fieldId'] == 'start_date' }
      field['settings'] = { 'format' => 'dateonly'}
      field = controls.detect { |e| e['fieldId'] == 'end_date' }
      field['settings'] = { 'format' => 'dateonly'}

      editor_interface.update(controls: controls)
      editor_interface.reload

      content_type.save
      content_type.publish

    end
  end
end
