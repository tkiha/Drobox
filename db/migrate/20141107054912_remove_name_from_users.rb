class RemoveNameFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :name, :string
    remove_column :users, :mail, :string
    remove_column :users, :password, :string
 end
end
