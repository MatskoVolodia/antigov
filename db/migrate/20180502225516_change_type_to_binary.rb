class ChangeTypeToBinary < ActiveRecord::Migration[5.1]
  def up
    change_column :units, :encoded, :binary
  end

  def down
    change_column :units, :encoded, :bytea
  end
end
