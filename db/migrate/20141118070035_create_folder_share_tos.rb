class CreateFolderShareTos < ActiveRecord::Migration
  def change
    create_table :folder_share_tos do |t|
      t.integer :folder_share_id
      t.integer :user_id

      t.timestamps
    end
  end
end
