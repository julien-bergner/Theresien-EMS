class CreateDanceTrainingRegistrations < ActiveRecord::Migration
  def change
    create_table :dance_training_registrations do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.integer :amount

      t.timestamps
    end
  end
end
