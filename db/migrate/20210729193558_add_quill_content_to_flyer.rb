class AddQuillContentToFlyer < ActiveRecord::Migration[5.2]
  def change
    add_column :flyers, :quill_content, :json
  end
end
