class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :password_digest
      t.datetime :birth_date
      t.integer :sex
      t.text :introduction

      t.timestamps
    end
  end
end
