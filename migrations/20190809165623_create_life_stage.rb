class CreateLifeStage < RevertableMigration

  self.content_type_id = 'life_stage'

  def up
    with_space do |space|
      content_type = space.content_types.create(
        name: 'Life Stage',
        id: content_type_id,
        description: 'Content for the major mile stones of life!'
      )

      content_type.fields.create(id: 'title', name: 'Title', type: 'Symbol', required: true)
      content_type.fields.create(id: 'description', name: 'Description', type: 'Text')
      content_type.fields.create(id: 'image', name: 'Image', type: 'Link', link_type: 'Asset', required: true)
      content_type.fields.create(id: 'content', name: 'Content', type: 'Array', items: items_of_type('Entry', ['article','podcast','video','message','series', 'episode']))

      content_type.save
      content_type.publish
    end
  end

end
