class AddNamesToEvents < ActiveRecord::Migration
  def change
    add_column :events, :folder_name, :text
    add_column :events, :upfile_name, :text
  end
end
