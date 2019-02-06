require_relative '../lib/revertable_migration'

class CreateSystemPages < RevertableMigration

  self.content_type_id = 'system_page'

  def up
    with_space do |space|
      content_type = space.content_types.create(
        name: 'System Page',
        id: content_type_id,
        description: 'crds-angular routing support; application search record support'
      )

      content_type.fields.create(id: 'title', name: 'Title', type: 'Symbol', required: true)
      content_type.fields.create(id: 'url', name: 'URL', type: 'Symbol', required: true, validations: [uniqueness_of])
      content_type.fields.create(id: 'description', name: 'Description', type: 'Text')
      content_type.fields.create(id: 'image', name: 'Image URL', type: 'Symbol')
      content_type.fields.create(id: 'stateName', name: 'State Name', type: 'Symbol', required: true)
      content_type.fields.create(id: 'legacyStyles', name: 'Legacy Styles?', type: 'Boolean', required: true)
      content_type.fields.create(id: 'bodyClasses', name: 'Body Classes', type: 'Text')

      content_type.save
      content_type.publish
    end
  end

end
