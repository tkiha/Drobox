class CreateUpfiles < ActiveRecord::Migration
  def change
    create_table :upfiles do |t|
      t.string :name
      t.string :realname
      t.integer :folder_id

      t.timestamps
    end
  end
end
