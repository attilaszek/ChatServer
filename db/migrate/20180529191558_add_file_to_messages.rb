class AddFileToMessages < ActiveRecord::Migration[5.1]
  def change
    add_column :messages, :file_b64, :text
  end
end
