class CreateOnsiteGroup < RevertableMigration	

  self.content_type_id = 'onsite_group'	

  def up
    with_space do |space|
      content_type = space.content_types.create(	
         name: 'Onsite Group',	
         id: content_type_id,	
         description: 'An onsite group'	
       )

      content_type.fields.create(id: 'title', name: 'Title', type: 'Symbol', required: true)	
      content_type.fields.create(id: 'slug', name: 'slug', type: 'Symbol', required: true)
      content_type.fields.create(id: 'description', name: 'Description', type: 'Text', required: true)	
      content_type.fields.create(id: 'length', name: 'Length', type: 'Symbol', required: true)	
      content_type.fields.create(id: 'detail', name: 'Detail', type: 'Text', required: true)
      content_type.fields.create(id: 'meetings', name: 'Meetings', type: 'Array', items: items_of_type('Entry', 'onsite_group_meeting'))
      content_type.fields.create(id: 'category', name: 'Category', type: 'Link', link_type: 'Entry', validations: [validation_of_type('onsite_group_category')])
      content_type.fields.create(id: 'footnote', name: 'Footnote', type: 'Text')

      content_type.activate

      editor_interface = content_type.editor_interface.default
      controls = editor_interface.controls

      controls.detect { |e| e['fieldId'] == 'Length' }['settings'] = { 'helpText' => 'How long the group will be active for. ie. 12 weeks' }
      controls.detect { |e| e['fieldId'] == 'Detail' }['settings'] = { 'helpText' => 'Who the group is perfect for. ie. Woman of all ages' }

      editor_interface.update(controls: controls)
      editor_interface.reload

      content_type.activate
      apply_editor(content_type, 'slug', 'slugEditor')	
      content_type.publish
    end
  end
end
