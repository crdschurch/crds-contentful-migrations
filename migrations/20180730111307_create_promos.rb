class CreatePromos < RevertableMigration

  self.content_type_id = 'promo'

  def up
    with_space do |space|
      content_type = space.content_types.create(
        name: 'Promos',
        id: content_type_id,
        description: 'Share your message with the world'
      )

      content_type.fields.create(id: 'title', name: 'Title', type: 'Symbol', required: true)
      content_type.fields.create(id: 'image', name: 'Image', type: 'Link', link_type: 'Asset')
      content_type.fields.create(id: 'description', name: 'Description', type: 'Text')
      content_type.fields.create(id: 'cta', name: 'Call To Action', type: 'Symbol')
      content_type.fields.create(id: 'link_url', name: 'Link URL', type: 'Symbol')
      content_type.fields.create(id: 'target_audience', name: 'Target Audience', type: 'Array', validations: [
        in('Churchwide', 'Andover', 'Columbus', 'Cleveland', 'Dayton', 'East Side', 'Florence',
          'Georgetown', 'Downtown Lexington', 'Mason', 'Oakley', 'Oxford', 'Richmond', 'Uptown', 'West Side')
      ])

      content_type.save
      content_type.publish
    end
  end

end
