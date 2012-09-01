class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :status
      t.float :amount
      t.string :delivery_method
      t.integer :customer_id

      t.timestamps
    end
  end
end
