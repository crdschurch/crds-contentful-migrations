require_relative '../lib/revertable_migration'

class CreateContentBlocks < RevertableMigration

  self.content_type_id = 'content_block'

  def up
    with_space do |space|
      content_type = space.content_types.create(
        name: 'Content Block',
        id: content_type_id,
        description: 'Imported content blocks from SS'
      )

      content_type.fields.create(id: 'id', name: 'ID', type: 'Integer', required: true, validations: [uniqueness_of])
      content_type.fields.create(id: 'title', name: 'Title', type: 'Symbol', required: true, validations: [uniqueness_of])
      content_type.fields.create(id: 'content', name: 'Content', type: 'Text')
      validation_for_type = Contentful::Management::Validation.new
      validation_for_type.in = ['success', 'error', 'warning', 'info']
      content_type.fields.create(id: 'type', name: 'Type', type: 'Symbol', required: true, validations: [validation_for_type])
      validation_for_category = Contentful::Management::Validation.new
      validation_for_category.in = ['common', 'main', 'corkboard', 'trip application', 'group tool', 'echeck', 'giving', 'ddk', 'finder', 'group leader', 'shared leader', 'serve', 'wayfinder']
      content_type.fields.create(id: 'category', name: 'Category', type: 'Symbol', required: true, validations: [validation_for_category])
      validation_for_class_name = Contentful::Management::Validation.new
      validation_for_class_name.in = ['ContentBlock']
      content_type.fields.create(id: 'class_name', name: 'Class Name', type: 'Symbol', required: true, validations: [validation_for_class_name])
      content_type.save
      content_type.publish
    end
  end
end
