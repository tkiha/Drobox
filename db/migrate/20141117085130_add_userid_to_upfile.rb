class AddUseridToUpfile < ActiveRecord::Migration
  def change
    add_column :upfiles, :user_id, :integer
  end
end
