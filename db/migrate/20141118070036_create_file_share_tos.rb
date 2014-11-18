class CreateFileShareTos < ActiveRecord::Migration
  def change
    create_table :file_share_tos do |t|
      t.integer :file_share_id
      t.integer :user_id

      t.timestamps
    end
  end
end
