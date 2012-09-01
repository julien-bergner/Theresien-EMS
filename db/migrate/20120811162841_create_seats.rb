class CreateSeats < ActiveRecord::Migration
  def change
    create_table :seats do |t|
      t.integer :prom_table_id
      t.integer :order_id
      t.integer :position
      t.string :caption
      t.integer :price
      t.integer :status

      t.timestamps
    end
  end
end
