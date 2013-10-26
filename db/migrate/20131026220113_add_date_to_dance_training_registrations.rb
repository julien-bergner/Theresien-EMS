class AddDateToDanceTrainingRegistrations < ActiveRecord::Migration
  def change
    add_column :dance_training_registrations, :date, :string
  end
end
