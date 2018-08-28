class CreatePromos < RevertableMigration

  self.content_type_id = 'promo'

  def up
    with_space do |space|
      content_type = space.content_types.create(
        name: 'Promo',
        id: content_type_id,
        description: 'Share your message with the world'
      )

      content_type.fields.create(id: 'title', name: 'Title', type: 'Symbol', required: true)
      content_type.fields.create(id: 'image', name: 'Image', type: 'Link', link_type: 'Asset')
      content_type.fields.create(id: 'description', name: 'Description', type: 'Text')
      content_type.fields.create(id: 'link_url', name: 'Link URL', type: 'Symbol')
      content_type.fields.create(id: 'published_at', name: 'Published At', type: 'Date', required: true)

      validations_for_section = Contentful::Management::Validation.new
      validations_for_section.in = ["Don't Miss", 'Be The Church']
      
      validations_for_target = Contentful::Management::Validation.new
      validations_for_target.in = ['Churchwide', 'Andover', 'Columbus', 'Cleveland', 'Dayton', 'East Side', 'Florence', 'Georgetown', 'Downtown Lexington', 'Mason', 'Oakley', 'Oxford', 'Richmond', 'Uptown', 'West Side']

      section_items = Contentful::Management::Field.new
      section_items.type = 'Symbol'
      section_items.validations = [validations_for_section]

      target_items = Contentful::Management::Field.new
      target_items.type = 'Symbol'
      target_items.validations = [validations_for_target]

      content_type.fields.create(id: 'section', name: 'Section', type: 'Array', items: section_items)
      content_type.fields.create(id: 'target_audience', name: 'Target Audience', type: 'Array', items: target_items)
      
      content_type.save
      content_type.publish
    end
  end

end
