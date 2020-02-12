class CreateTripItinerary < RevertableMigration

  self.content_type_id = 'trip_itinerary'

  def up
    with_space do |space|
      # Create content model
      content_type = space.content_types.create(
        name: 'Trip Itinerary',
        id: content_type_id,
        description: 'Itinerary for Go Trips', 
      )

      # Create fields
      content_type.fields.create(id: 'day', name: 'Day', type: 'Symbol', required: true)
      content_type.fields.create(id: 'activities', name: 'Activities', type: 'Symbol', required: true)

      # Save & Publish
      content_type.save
      content_type.publish

      # Set Entry Title
      content_type = space.content_types.find('trip_itinerary')
      content_type.update(displayField: 'day')

      content_type.save
      content_type.publish
    end
  end
end
