class AddClassToDanceTrainingRegistrations < ActiveRecord::Migration
  def change
    add_column :dance_training_registration, :date, :string
  end
end
