class UpdateMsgBgImgToRequired < ContentfulMigrations::Migration

  include MigrationUtils

  def up
    with_space do |space|
    content_type = space.content_types.find('message')
    field = content_type.fields.detect { |f| f.id == 'background_image'}
    field.required = true

    content_type.save
    content_type.publish
    end
  end
end
