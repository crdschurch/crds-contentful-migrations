class CreateTripPartner < RevertableMigration

  self.content_type_id = 'trip_partner'
  def up
    with_space do |space|
      # Create content model
      content_type = space.content_types.create(
        name: 'Trip Partner',
        id: content_type_id,
        description: 'Partner for Go Trips', 
      )

      # Create fields
      content_type.fields.create(id: 'partner_name', name: 'Partner Name', type: 'Symbol')
      content_type.fields.create(id: 'partner_description', name: 'Partner Description', type: 'Text')
      content_type.fields.create(id: 'partner_video', name: 'Partner Video URL', type: 'Symbol')
      content_type.fields.create(id: 'partner_image', name: 'Partner Image', type: 'Link', link_type: 'Asset')
      content_type.fields.create(id: 'partner_website', name: 'Partner Website URL', type: 'Symbol')
      
      # Save & Publish
      content_type.save
      content_type.publish

      # Set Entry Title
      content_type = space.content_types.find('trip_partner')
      content_type.update(displayField: 'partner_name')

      content_type.save
      content_type.publish
    end
  end
end