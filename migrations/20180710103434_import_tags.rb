# Loop through each JSON entry by ID
# Update tags field for each entry for the associated tags

# Use the key to get the entry in Contentful
# Get an array of tag entry objects
# And then update the entry with the array of entries
# Publish

# Bonus: Find a clever way to grab all entries first (account for pagination) so when you loop through the JSON object

require 'active_support/core_ext/string'

class ImportTags < ContentfulMigrations::Migration
  def up
    with_space do |space|
      file = File.read "./tag-export.json"
      data = JSON.parse(file)
      unique_tags = data.values.flatten.uniq
      tag_type = space.content_types.find('tag')

      unique_tags.each do |tag|
        entry = tag_type.entries.create(title: tag, slug: tag.parameterize)
        if publish_entry(entry)
          puts "Created tag: #{tag}"
        else
          puts "Error: #{tag}"
        end

        sleep 0.21
      end
    end
  end

  def down
    with_space do |space|
      tag_type = space.content_types.find('tag')

      entries = tag_type.entries.all(limit: 1000)

      entries.each do |entry|
        entry.unpublish
        entry.destroy

        puts "Deleted tag: #{tag}"
        sleep 0.21
      end
    end
  end

  private

  def publish_entry(entry)
    pub = entry.publish
    unless pub.is_a?(Contentful::Management::Entry)
      return false unless pub.message.include?('slug')
      entry.fetch_content_type rescue nil
      slug = "#{entry.fields[:slug]}-#{entry.id}"
      entry.update(slug: slug)
      return publish_entry(entry)
    end
    true
  end
end
