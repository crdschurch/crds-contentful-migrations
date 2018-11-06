require_relative '../lib/revertable_migration'

class CreateRedirects < RevertableMigration

  self.content_type_id = 'redirect'

  def up
    with_space do |space|
      content_type = space.content_types.create(
        name: 'Redirect',
        id: content_type_id,
        description: 'URL redirects'
      )

      validation_for_status = Contentful::Management::Validation.new
      validation_for_status.in = ['temporary', 'permanent']

      content_type.fields.create(id: 'from', name: 'From', type: 'Symbol', required: true, validations: [uniqueness_of])
      content_type.fields.create(id: 'to', name: 'To', type: 'Symbol', required: true)
      content_type.fields.create(id: 'status', name: 'Status', type: 'Symbol', required: true, validations: [validation_for_status])

      content_type.save
      content_type.publish
    end
  end

end
