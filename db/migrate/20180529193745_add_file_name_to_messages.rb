class AddFileNameToMessages < ActiveRecord::Migration[5.1]
  def change
    add_column :messages, :file_name, :string
  end
end
