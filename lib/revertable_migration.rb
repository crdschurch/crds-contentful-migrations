require 'migration_utils'

class RevertableMigration < ContentfulMigrations::Migration
  include MigrationUtils

  @@content_type_id = nil

  def initialize(name = self.class.name, version = nil, client = nil, space = nil)
    raise ContentTypeNotDefined if content_type_id.nil?
    super(name, version, client, space)
  end

  def down
    with_space do |space|
      content_type = space.content_types.find(content_type_id)
      content_type.unpublish
      content_type.destroy
    end
  end

  protected

    def content_type_id
      @content_type_id ||= @@content_type_id
    end

  class ContentTypeNotDefined < ::StandardError
    def message
      "When inheriting from RevertableMigration, you must specify @@content_type_id in your subclass"
    end
  end
end
