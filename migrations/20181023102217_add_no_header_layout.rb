class AddNoHeaderLayout < ContentfulMigrations::Migration
  
  include MigrationUtils

  def up
    with_space do |space|
      content_type = space.content_types.find('page')
      field = content_type.fields.detect { |f| f.id == 'layout' }
      validations = field.validations.first.in
      new_layout = 'no-header-no-footer'
      validations.push(new_layout)

      content_type.save
      content_type.publish
    end
  end

  def down
    with_space do |space|
      content_type = space.content_types.find('page')
      field = content_type.fields.detect { |f| f.id == 'layout' }
      validations = field.validations.first.in
      validations.pop

      content_type.save
      content_type.publish
    end
  end

end
