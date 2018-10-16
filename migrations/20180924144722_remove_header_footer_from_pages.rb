class RemoveHeaderFooterFromPages < ContentfulMigrations::Migration

  include MigrationUtils

  def up
    with_space do |space|
      content_type = space.content_types.find('page')
      show_header_field = content_type.fields.detect { |f| f.id == 'show_header' }
      show_footer_field = content_type.fields.detect { |f| f.id == 'show_footer' }
      if show_header_field
        show_header_field.omitted = true
        show_header_field.disabled = true
      end
      if show_footer_field
        show_footer_field.omitted = true
        show_footer_field.disabled = true
      end
      content_type.save
      content_type.fields.destroy(show_header_field) if show_header_field
      content_type.fields.destroy(show_footer_field) if show_footer_field
      content_type.save
      content_type.publish
    end
  end
end
