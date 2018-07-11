# Loop through each JSON entry by ID
# Update tags field for each entry for the associated tags

# Use the key to get the entry in Contentful
# Get an array of tag entry objects
# And then update the entry with the array of entries
# Publish

# Bonus: Find a clever way to grab all entries first (account for pagination) so when you loop through the JSON object

class AddTagsToMedia < ContentfulMigrations::Migration
  def up
    with_space do |space|
      file = File.read "./tag-export.json"
      data = JSON.parse(file)
      tag_type = space.content_types.find('tag')
      all_tags = tag_type.entries.all(limit: 1000)

      def fetch_entries(space, entries = [])
        new_entries = space.entries.all(limit: 1000, skip: entries.size).to_a
        entries.concat(new_entries)
        new_entries.size == 1000 ? fetch_entries(space, entries) : entries
      end

      entries = fetch_entries(space)

      data.each do |id, tag_names|
        # binding.pry
        entry = entries.detect{|e| e.id.to_i == id.to_i}
        tags = all_tags.select{|t| tag_names.include?(t.title)}

        entry.update(tags: tags)
        entry.publish

        puts "Updated entry: #{id}"

        sleep 0.21
      end
    end
  end

  # def down
  #   with_space do |space|
  #   end
  # end
end