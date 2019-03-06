require_relative '../lib/revertable_migration'

class CreateSignUpForms < RevertableMigration
  self.content_type_id = 'sign_up_form'

  def up
    with_space do |space|
      content_type = space.content_types.create(
        name: 'Sign-Up Form',
        id: content_type_id,
        description: 'Legacy sign-up forms rendered by angular'
      )
      validation_for_meta_description = Contentful::Management::Validation.new
      validation_for_meta_description.size = { min: 100, max: 155 }
      validation_for_className = Contentful::Management::Validation.new
      validation_for_className.in = ['CommunityGroupSignupPage','OnetimeEventSignupPage','ServingGroupSignupPage','SignupHolder']

      content_type.fields.create(id: 'title', name: 'Title', type: 'Symbol', required: true)
      content_type.fields.create(id: 'link', name: 'Link', type: 'Symbol', required: true, validations: [uniqueness_of])
      content_type.fields.create(id: 'content', name: 'Content', type: 'Text')
      content_type.fields.create(id: 'className', name: 'Class Name', type: 'Symbol', required: true, validations: [validation_for_className])
      content_type.fields.create(id: 'pageType', name: 'Page Type', type: 'Symbol', required: true, validations: [validation_for_className])
      content_type.fields.create(id: 'opportunity', name: 'Opportunity', type: 'Integer')
      content_type.fields.create(id: 'group', name: 'Group', type: 'Integer')
      content_type.fields.create(id: 'existingMember', name: 'Existing Member', type: 'Text')
      content_type.fields.create(id: 'success', name: 'Success', type: 'Text')
      content_type.fields.create(id: 'waitList', name: 'Wait List', type: 'Text')
      content_type.fields.create(id: 'waitSuccess', name: 'Wait Success', type: 'Text')
      content_type.fields.create(id: 'full', name: 'Full', type: 'Text')
      content_type.fields.create(id: 'meta', name: 'Meta', type: 'Link', link_type: 'Entry', validations: [validation_of_type('meta')])

      items = Contentful::Management::Field.new
      items.type = 'Symbol'
      content_type.fields.create(id: 'tags', name: 'Tags', type: 'Array', items: items)

      content_type.save
      content_type.publish
    end
  end
end
