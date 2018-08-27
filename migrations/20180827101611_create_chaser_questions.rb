class CreateChaserQuestions < RevertableMigration

  self.content_type_id = 'chaser_question'

  def up
    with_space do |space|
      content_type = space.content_types.create(
        name: 'Chaser Question',
        id: content_type_id,
        description: 'Questions to be added to The Chaser.'
      )

      content_type.fields.create(id: 'title', name: 'Title', type: 'Symbol', required: true)
      content_type.fields.create(id: 'question', name: 'Question', type: 'Text', required: true)

      content_type.save
      content_type.publish
    end
  end

  def down
    with_space do |space|
      content_type = space.content_types.find('chaser_question')
      content_type.deactivate
      content_type.destroy
    end
  end
end