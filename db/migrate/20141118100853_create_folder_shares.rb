class CreateFolderShares < ActiveRecord::Migration
  def change
    create_table :folder_shares do |t|
      t.string :name
      t.integer :folder_id
      t.integer :from_user_id
      t.integer :to_user_id

      t.timestamps
    end
  end
end
