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
        entry = entries.detect{|e| e.id == id}
        tags = all_tags.select{|t| tag_names.include?(t.title)}

        entry.update(tags: tags)
        entry.publish

        puts "Updated entry: #{id}"

        sleep 0.21
      end
    end
  end
end