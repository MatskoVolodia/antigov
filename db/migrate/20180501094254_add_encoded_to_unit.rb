class AddEncodedToUnit < ActiveRecord::Migration[5.1]
  def change
    add_column :units, :encoded, :bytea
  end
end
