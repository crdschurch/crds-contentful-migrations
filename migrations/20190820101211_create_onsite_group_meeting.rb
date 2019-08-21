class CreateOnsiteGroupMeeting < RevertableMigration	

  self.content_type_id = 'onsite_group_meeting'	

  def up	
   with_space do |space|	
    content_type = space.content_types.create(	
      name: 'Onsite Group Meeting',	
      id: content_type_id,	
      description: 'An individual meeting for onsite groups'	
    )	

    content_type.fields.create(id: 'title', name: 'Title', type: 'Symbol', required: true)	
    content_type.fields.create(id: 'registration_link', name: 'Registration Link', type: 'Symbol', required: true)	
    content_type.fields.create(id: 'location', name: 'Location', type: 'Link', link_type: 'Entry', validations: [validation_of_type('location')])	
    content_type.fields.create(id: 'description', name: 'Description', type: 'Text', required: true)	
    content_type.fields.create(id: 'starts_at', name: 'Starts at', type: 'Date', required: true)	
    content_type.fields.create(id: 'meeting_time', name: 'Meeting Time', type: 'Text', required: true)	

    content_type.save
    content_type.publish

    editor_interface = content_type.editor_interface.default
    controls = editor_interface.controls
    controls.detect { |e| e['fieldId'] == 'location' }['settings'] = { 'helpText' => 'If you do not specify location, be sure to link this meeting to the corresponding Onsite Group otherwise it will not be displayed' }
    editor_interface.update(controls: controls)
    editor_interface.reload

    content_type.save	
    content_type.publish	
   end	
 end	
end 