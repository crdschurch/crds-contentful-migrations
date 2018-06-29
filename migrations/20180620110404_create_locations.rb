class CreateLocations < RevertableMigration

  self.content_type_id = 'location'

  def up
    with_space do |space|
      content_type = space.content_types.create(
        name: 'Location',
        id: content_type_id,
        description: 'Models the attributes of a Crossroads community site'
      )
      content_type.fields.create(id: 'name', name: 'Name', type: 'Symbol', required: true)
      content_type.fields.create(id: 'description', name: 'Description', type: 'Text', required: true) # block of text describing the location
      content_type.fields.create(id: 'image', name: 'Image', type: 'Link', link_type: 'Asset', required: true)
      content_type.fields.create(id: 'slug', name: 'Slug', type: 'Symbol', required: true, validations: [uniqueness_of])
      content_type.fields.create(id: 'service_times_label', name: 'Service Times Label', type: 'Symbol')
      content_type.fields.create(id: 'service_times', name: 'Service Times', type: 'Text')
      content_type.fields.create(id: 'weekday_hours', name: 'Weekday Hours', type: 'Text')
      content_type.fields.create(id: 'weekday_hours_image', name: 'Weekday Hours Image', type: 'Link', link_type: 'Asset')
      content_type.fields.create(id: 'weekday_hours_description', name: 'Weekday Hours Description', type: 'Text')
      content_type.fields.create(id: 'additional_info', name: 'Additional Info', type: 'Text') # e.g. ASL accessibility info, Downtown Lexington card link (which diverges from all other implementations)
      content_type.fields.create(id: 'address', name: 'Address', type: 'Text')
      content_type.fields.create(id: 'map_url', name: 'Map Url', type: 'Text') # potentially longer than 256 characters, so Text (50K) instead of Symbol
      content_type.fields.create(id: 'virtual_tour_url', name: 'Virtual Tour Url', type: 'Text') # potentially longer than 256 characters, so Text (50K) instead of Symbol
      content_type.fields.create(id: 'come_as_you_are_image', name: 'Come As You Are Image', type: 'Link', link_type: 'Asset')
      content_type.fields.create(id: 'community_pastor_name', name: 'Community Pastor Name', type: 'Symbol')
      content_type.fields.create(id: 'community_pastor_bio', name: 'Community Pastor Bio', type: 'Text')
      content_type.fields.create(id: 'community_pastor_image', name: 'Community Pastor Image', type: 'Link', link_type: 'Asset')

# Excluding "happenings" for now in order to better understand the domain and break the ambiguity up into instantly knowable entities/content types
# content_type.fields.create(id: 'happenings', name: 'Happenings', type: 'Array', items: items_of_type('Entry', 'happening'))

      validation_in = Contentful::Management::Validation.new
      validation_in.in = ['default']
      content_type.fields.create(id: 'layout', name: 'Layout', type: 'Symbol', required: true, validations: [validation_in])

      items = Contentful::Management::Field.new
      items.type = 'Symbol'
      content_type.fields.create(id: 'tags', name: 'Tags', type: 'Array', items: items)

      content_type.save
      content_type.publish
      apply_editor(space, 'slug', 'slugEditor')
    end
  end
end