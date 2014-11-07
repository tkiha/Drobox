class CreateFileShares < ActiveRecord::Migration
  def change
    create_table :file_shares do |t|
      t.string :name
      t.integer :from_user_id
      t.integer :to_user_id
      t.integer :file_id

      t.timestamps
    end
  end
end
