class RemoveNameFromFolderShare < ActiveRecord::Migration
  def change
    remove_column :folder_shares, :name, :string
  end
end
