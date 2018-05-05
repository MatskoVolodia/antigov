class AddStatusToUnits < ActiveRecord::Migration[5.1]
  def change
    add_column :units, :status, :integer, default: 0
  end
end
