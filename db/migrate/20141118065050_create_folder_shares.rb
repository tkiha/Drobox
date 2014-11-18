class CreateFolderShares < ActiveRecord::Migration
  def change
    create_table :folder_shares do |t|
      t.string :name
      t.integer :folder_id
      t.integer :user_id

      t.timestamps
    end
  end
end
