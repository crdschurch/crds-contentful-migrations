class CreateOnsiteGroup < RevertableMigration	

  self.content_type_id = 'onsite_group'	

  def up
    with_space do |space|
      content_type = space.content_types.create(	
         name: 'Onsite group',	
         id: content_type_id,	
         description: 'An onsite group'	
       )

       content_type.fields.create(id:'title', name:'Title', type:'Symbol', required: true)	
       content_type.fields.create(id:'slug', name:'slug', type:'Symbol', required:true)
       content_type.fields.create(id:'description', name:'Description', type:'Symbol', required:true)	
       content_type.fields.create(id:'detail', name:'Detail', type:'Symbol', required:true)
       content_type.fields.create(id:'meetings', name:'Meetings', type:'Array', items:items_of_type('Entry', 'onsite_group_meeting'))
       content_type.fields.create(id: 'category', name: 'Category', type: 'Link', link_type: 'Entry', validations: [validation_of_type('onsite_group_category')])

       content_type.save	
       content_type.publish	
       apply_editor(space, 'slug', 'slugEditor')	
    end
  end
end
