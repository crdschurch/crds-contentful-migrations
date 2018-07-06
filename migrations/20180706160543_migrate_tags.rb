class MigrateTags

  def up
    content_types = %w[article episode video message song]

    def fetch_entries(content_type, entries = [])
      new_entries = content_type.entries.all(limit: 1000, skip: entries.size).to_a
      entries.concat(new_entries)
      new_entries.size == 1000 ? fetch_entries(content_type, entries) : entries
    end

    content_export = {}

    content_types.each do |name|
      content_type = space.content_types.find(name)
      entries = fetch_entries(content_type)

      entries.each do |entry|
        next if entry.tags.nil?
        content_export[entry.id] = entry.tags
      end
    end

    File.open('./tag-export.json', 'w+') do |file|
      file.write(content_export.to_json)
    end
  end
end