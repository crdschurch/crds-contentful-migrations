class CreateEngagementBlock < RevertableMigration

  self.content_type_id = 'engagement_block'
  def up
    with_space do |space|
      # Create content model
      content_type = space.content_types.create(
        name: 'Engagement Block',
        id: content_type_id,
        description: 'Meta data for user engagement achievements.', 
      )

      # Create fields
      content_type.fields.create(id: 'title', name: 'Title', type: 'Symbol', required: true)
      content_type.fields.create(id: 'description', name: 'Description', type: 'Text')
      content_type.fields.create(id: 'target_url', name: 'Target Url', type: 'Symbol', required: true)	
      content_type.fields.create(id: 'tooltip_earned_content', name: 'Tool Tip Earned Content', type: 'Text')
      content_type.fields.create(id: 'tooltip_unearned_content', name: 'Tool Tip Unearned Content', type: 'Text')

      validation_for_type = Contentful::Management::Validation.new
      validation_for_type.in = ['Badge', 'Activity']
      content_type.fields.create(id: 'type', name: 'Type', type: 'Symbol', required: true, validations: [validation_for_type])
      content_type.fields.create(id: 'enagement_id', name: 'Engagement ID', type: 'Integer')
      content_type.fields.create(id: 'disabled', name: 'Disabled', type: 'Boolean', required: true)
      
      # Save & Publish
      content_type.save
      content_type.publish
    end
  end
end
