class CreateUnits < ActiveRecord::Migration[5.1]
  def change
    create_table :units do |t|
      t.column :file, :oid, null: false

      t.timestamps
    end
  end
end
