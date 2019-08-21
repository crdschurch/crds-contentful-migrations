module MigrationUtils

  attr_accessor :type

  def uniqueness_of
    validation = Contentful::Management::Validation.new
    validation.unique = true
    validation
  end

  def require_mime_type(*types)
    validation = Contentful::Management::Validation.new
    validation.link_mimetype_group = types.collect(&:to_s)
    validation
  end

  def apply_editor(content_type, field, editor, type=nil)
    editor_interface = content_type.editor_interface.default
    controls = editor_interface.controls
    controls.detect { |c| c['fieldId'] == field }['widgetId'] = editor
    editor_interface.update(controls: controls)
    editor_interface.reload
  end

  def items_of_type(link_type, validates=nil)
    items = Contentful::Management::Field.new
    items.type = 'Link'
    items.link_type = link_type
    unless validates.nil?
      validations = [ validation_of_type(validates) ]
      items.validations = validations
    end
    items
  end

  def validation_of_type(*types)
    validation_link_content_type = Contentful::Management::Validation.new
    validation_link_content_type.link_content_type = types.flatten
    validation_link_content_type
  end

end