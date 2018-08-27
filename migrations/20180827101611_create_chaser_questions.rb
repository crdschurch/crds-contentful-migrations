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

      with_editor_interfaces do |editor_interfaces|
        editor_interface = editor_interfaces.default(space.id, content_type_id)
        controls = editor_interface.controls
        controls.detect { |e| e['fieldId'] == 'title' }['settings'] = { 'helpText' => 'If your question is associated with a Chaser, a descriptive title will make it easier to find and link it appropriately. Note: This field is for labeling purposes and will not be reflected outside of Contentful.' }
        editor_interface.update(controls: controls)
        editor_interface.reload
      end

      content_type.save
      content_type.publish
    end
  end
end