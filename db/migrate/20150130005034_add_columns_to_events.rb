class AddColumnsToEvents < ActiveRecord::Migration
  def change
    add_column :events, :folder_id, :integer
    add_column :events, :upfile_id, :integer
  end
end
