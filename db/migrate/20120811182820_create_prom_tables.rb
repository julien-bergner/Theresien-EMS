class CreatePromTables < ActiveRecord::Migration
  def change
    create_table :prom_tables do |t|
      t.integer :position
      t.string :caption
      t.integer :price

      t.timestamps
    end
  end
end
