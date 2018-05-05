class RemoveContentAndAddTitle < ActiveRecord::Migration[5.1]
  def change
    remove_column :units, :content
    add_column :units, :title, :bytea
  end
end
