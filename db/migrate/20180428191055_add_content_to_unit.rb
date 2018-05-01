class AddContentToUnit < ActiveRecord::Migration[5.1]
  def change
    add_column :units, :content, :bytea
  end
end
