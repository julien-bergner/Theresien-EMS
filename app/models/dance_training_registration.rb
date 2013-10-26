class DanceTrainingRegistration < ActiveRecord::Base
  attr_accessible :amount, :email, :first_name, :last_name, :date

  validates_presence_of :amount, :email, :first_name, :last_name, :date
  validates_format_of :email, :with => /(^$|^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$)/i, :message => "Bitte geben Sie eine g&uuml;ltige E-Mail-Adresse ein."
end
