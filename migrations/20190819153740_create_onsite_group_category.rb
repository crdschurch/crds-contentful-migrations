class CreateOnsiteGroupCategory < RevertableMigration	

  self.content_type_id = 'onsite_group_category'	

  def up	
   with_space do |space|	
     content_type = space.content_types.create(	
       name: 'onsite_group_category',	
       id: content_type_id,	
       description: 'A category for onsite groups'	
     )	

     content_type.fields.create(id: 'title', name: 'Title', type: 'Symbol', required: true)	
     content_type.fields.create(id: 'slug', name: 'Slug', type: 'Symbol', required: true, validations: [uniqueness_of])	
     content_type.fields.create(id: 'description', name: 'Description', type: 'Text')	
     content_type.fields.create(id: 'image', name: 'Image', type: 'Link', link_type: 'Asset', required: true)	

     content_type.save	
     content_type.publish	
     apply_editor(space, 'slug', 'slugEditor')	
   end	
 end	
end 