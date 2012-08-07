class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string :designation
      t.string :first_name
      t.string :last_name
      t.string :street_name
      t.string :street_number
      t.string :zip_code
      t.string :city
      t.string :email
      t.string :childrens_class

      t.timestamps
    end
  end
end
