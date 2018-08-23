class CreateLocations < RevertableMigration

  self.content_type_id = 'location'

  def up
    with_space do |space|
      content_type = space.content_types.create(
        name: 'Location',
        id: content_type_id,
        description: 'Models the attributes of a Crossroads community site'
      )

      content_type.fields.create(id: 'name', name: 'Name', type: 'Symbol', required: true)
      content_type.fields.create(id: 'slug', name: 'Slug', type: 'Symbol', required: true, validations: [uniqueness_of])
      content_type.fields.create(id: 'image', name: 'Image', type: 'Link', link_type: 'Asset', required: true)
      content_type.fields.create(id: 'bg_image', name: 'Background Image', type: 'Link', link_type: 'Asset', required: true)
      content_type.fields.create(id: 'description', name: 'Description', type: 'Text', required: true) # block of text describing the location
      content_type.fields.create(id: 'service_times', name: 'Service Times', type: 'Text')
      content_type.fields.create(id: 'address', name: 'Address', type: 'Text')
      content_type.fields.create(id: 'additional_info', name: 'Additional Info', type: 'Text') # e.g. ASL accessibility info, Downtown Lexington card link (which diverges from all other implementations)
      content_type.fields.create(id: 'map_url', name: 'Map Url', type: 'Text') # potentially longer than 256 characters, so Text (50K) instead of Symbol
      content_type.fields.create(id: 'virtual_tour_url', name: 'Virtual Tour Url', type: 'Text') # potentially longer than 256 characters, so Text (50K) instead of Symbol
      content_type.fields.create(id: 'come_as_you_are_image', name: 'Come As You Are Image', type: 'Link', link_type: 'Asset') #Image for 'come as you are' spotlight
      content_type.fields.create(id: 'community_pastor_image', name: 'Community Pastor Image', type: 'Link', link_type: 'Asset')
      content_type.fields.create(id: 'community_pastor_name', name: 'Community Pastor Name', type: 'Symbol')
      content_type.fields.create(id: 'community_pastor_bio', name: 'Community Pastor Bio', type: 'Text')
      content_type.fields.create(id: 'spotlight_image', name: 'Spotlight Image', type: 'Link', link_type: 'Asset')
      content_type.fields.create(id: 'spotlight_title', name: 'Spotlight Title', type: 'Symbol')
      content_type.fields.create(id: 'spotlight_text', name: 'Spotlight Text', type: 'Text')
      content_type.fields.create(id: 'kids_club_hours', name: 'Kid\'s Club Hours', type: 'Text')
      content_type.fields.create(id: 'student_ministry_hours', name: 'Student Ministry Hours', type: 'Text')
      content_type.fields.create(id: 'alternative_serve_url', name: 'Alternative Serve Url', type: 'Symbol')
      content_type.fields.create(id: 'hubspot_form_id', name: 'Hubspot Form ID', type: 'Symbol', validations: [uniqueness_of])

      # Set Editor UI
      with_editor_interfaces do |editor_interfaces|
        editor_interface = editor_interfaces.default(space.id, content_type_id)
        controls = editor_interface.controls
        controls.detect { |e| e['fieldId'] == 'image' }['settings'] = { 'helpText' => 'Used for cards and thumbnails' }
        controls.detect { |e| e['fieldId'] == 'bg_image' }['settings'] = { 'helpText' => 'Large image, used for jumbotron' }
        controls.detect { |e| e['fieldId'] == 'additional_info' }['settings'] = { 'helpText' => 'e.g. ASL interpreting provided by location' }
        controls.detect { |e| e['fieldId'] == 'map_url' }['settings'] = { 'helpText' => 'e.g. https://www.google.com/maps/place/3500+Madison+Rd,+Cincinnati,+OH+45209' }
        controls.detect { |e| e['fieldId'] == 'virtual_tour_url' }['settings'] = { 'helpText' => 'Google Maps Virtual Tour' }
        controls.detect { |e| e['fieldId'] == 'kids_club_hours' }['settings'] = { 'helpText' => 'Kid\'s Club content will only display if this field is populated' }
        controls.detect { |e| e['fieldId'] == 'student_ministry_hours' }['settings'] = { 'helpText' => 'Student Ministry content will only display if this field is populated' }
        controls.detect { |e| e['fieldId'] == 'hubspot_form_id' }['settings'] = { 'helpText' => 'This represents the form id (GUID) that represents a specific form in Hubspot; If this field is blank, the form will not show.' }
        controls.detect { |e| e['fieldId'] == 'alternative_serve_url' }['settings'] = { 'helpText' => 'This URL overrides the serve card located in the Go Deeper section' }
        editor_interface.update(controls: controls)
        editor_interface.reload
      end

      content_type.save
      content_type.publish
      apply_editor(space, 'slug', 'slugEditor')
    end
  end
end
