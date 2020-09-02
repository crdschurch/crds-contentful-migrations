class AddBitmovinHelperText < ContentfulMigrations::Migration
  include MigrationUtils

  def up
    with_space do |space|
      content_type = space.content_types.find('video')
      content_type.activate
      editor_interface = content_type.editor_interface.default
      controls = editor_interface.controls
      
      controls.detect { |e| e['fieldId'] == 'bitmovin_url' }['settings'] = { 'helpText' => 'If your video is over 1000 mb please contact DPT for help' }

      editor_interface.update(controls: controls)
      editor_interface.reload
      content_type.activate
      content_type.publish
    end
  end

  def down
    with_space do |space|
      content_type = space.content_types.find('video')
      content_type.activate
      editor_interface = content_type.editor_interface.default
      controls = editor_interface.controls

      controls.detect { |e| e['fieldId'] == 'bitmovin_url' }['settings'] = { 'helpText' => '' }

      editor_interface.update(controls: controls)
      editor_interface.reload
      content_type.activate
      content_type.publish
    end
  end
end
