class CreateHelpSections < ActiveRecord::Migration[5.2]
  def change
    create_table :help_sections do |t|
      t.string :section
      t.string :content
      t.json :quill_content

      t.timestamps
    end
    add_index :help_sections, :section
  end
end
