class Seat < ActiveRecord::Base
  attr_accessible :position, :caption, :prom_table_id, :price, :status
  belongs_to :prom_table
end