class Order < ActiveRecord::Base
  attr_accessible :amount, :customer_id, :delivery_method, :status
  has_many :seats
  belongs_to :customer
  accepts_nested_attributes_for :seats
end
