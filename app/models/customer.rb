class Customer < ActiveRecord::Base
  attr_accessible :childrens_class, :city, :designation, :email, :first_name, :last_name, :street_name, :street_number, :zip_code
end
