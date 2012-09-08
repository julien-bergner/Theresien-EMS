class PromTable < ActiveRecord::Base
  attr_accessible :position, :caption, :seat_description, :price, :orientation
  has_many :seats
end
