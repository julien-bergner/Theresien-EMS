class CreatePromTables < ActiveRecord::Migration
  def change
    create_table :prom_tables do |t|
      t.integer :position
      t.string :orientation
      t.string :caption
      t.string :seat_description
      t.float :price

      t.timestamps
    end
  end
end
