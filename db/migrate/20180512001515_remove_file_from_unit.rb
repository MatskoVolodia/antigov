class RemoveFileFromUnit < ActiveRecord::Migration[5.1]
  def change
    remove_column :units, :file
  end
end
