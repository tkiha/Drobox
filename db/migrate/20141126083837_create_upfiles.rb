class CreateUpfiles < ActiveRecord::Migration
  def change
    create_table :upfiles do |t|
      t.string :name
      t.binary :file_binary
      t.integer :folder_id
      t.integer :user_id

      t.timestamps
    end
  end
end
