class TestCi < ContentfulMigrations::Migration
  include MigrationUtils

  def up
    with_space do |space|
      content_type = space.content_types.find('page')
      content_type.save
      content_type.activate
    end
  end
end
