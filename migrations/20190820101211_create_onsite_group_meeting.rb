class CreateOnsiteGroupMeeting < RevertableMigration	

  self.content_type_id = 'create_onsite_group_meeting'	

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
     content_type.fields.create(id: 'start_date', name: 'Start Date', type: 'Text', required: true)	
     content_type.fields.create(id: 'meeting_time', name: 'Meeting Time', type: 'Text', required: true)	

     controls.detect { |e| e['fieldId'] == 'location' }['settings'] = { 'helpText' => 'If you do not specify location, be sure to add it to the corresponding group otherwise it will not be displayed' }

     apply_editor(space, 'slug', 'slugEditor')	

     content_type.save	
     content_type.publish	
   end	
 end	
end 