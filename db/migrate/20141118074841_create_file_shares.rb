class CreateFileShares < ActiveRecord::Migration
  def change
    create_table :file_shares do |t|
      t.string :name
      t.integer :upfile_id
      t.integer :user_id

      t.timestamps
    end
  end
end
