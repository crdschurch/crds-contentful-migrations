class AddFieldsToSignOff < ContentfulMigrations::Migration
  def up
    with_space do |space|
      content_type = space.content_types.find('sign_off')
      content_type.fields.create(id: 'background_image', name: 'Background Image', type: 'Link', link_type: 'Asset')
      content_type.fields.create(id: 'cta', name: 'CTA Text Area', type: 'Text')
      content_type.save
      content_type.publish
    end
  end

  def down
    with_space do |space|
      content_type = space.content_types.find('sign_off')

      %w(background_image cta).each do |field_name|
        field = content_type.fields.detect { |f| f.id == field_name }
        field.omitted = true
        field.disabled = true
      end

      content_type.save
      content_type.activate

      %w(background_image cta).each do |field_name|
        content_type.fields.destroy(field_name)
      end
      content_type.save
      content_type.publish
    end
  end
end
