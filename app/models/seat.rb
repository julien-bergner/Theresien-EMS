class Seat < ActiveRecord::Base
  attr_accessible :position, :caption, :prom_table_id, :prom_table, :price, :status, :order_id
  belongs_to :prom_table
  belongs_to :order
end
