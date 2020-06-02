class ChangeChallengeFieldNameOfDiscussion < ContentfulMigrations::Migration
  include MigrationUtils
  
  def up
    with_space do |space|
      content_type = space.content_types.find('discussion')
      field = content_type.fields.detect { |f| f.id == 'challenge' }
      field.name = 'More from the Weekend'
      content_type.save
      content_type.publish
    end
  end

  def down
    with_space do |space|
      content_type = space.content_types.find('discussion')
      field = content_type.fields.detect { |f| f.id == 'challenge' }
      field.name = 'Challenge'
      content_type.save
      content_type.publish
    end
  end
end
