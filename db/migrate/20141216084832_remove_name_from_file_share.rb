class RemoveNameFromFileShare < ActiveRecord::Migration
  def change
    remove_column :file_shares, :name, :string
  end
end
