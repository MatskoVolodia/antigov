class CreateChunks < ActiveRecord::Migration[5.1]
  def up
    create_table :chunks do |t|
      t.references :unit
      t.integer    :order

      t.timestamps
    end

    add_column :chunks, :encoded, :bytea

    remove_column :units, :encoded
  end

  def down
    drop_table :chunks

    add_column :units, :encoded, :bytea
  end
end
