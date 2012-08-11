class PromTable < ActiveRecord::Base
  attr_accessible :position, :caption, :price
  has_many :seats
end
