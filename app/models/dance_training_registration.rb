class DanceTrainingRegistration < ActiveRecord::Base
  attr_accessible :amount, :email, :first_name, :last_name, :date

  validates_presence_of :amount, :date
  validates_presence_of :first_name, :message => "Bitte geben Sie Ihren Vornamen ein."
  validates_presence_of :last_name, :message => "Bitte geben Sie Ihren Nachnnamen ein."
  validates_presence_of :email, :message => "Bitte geben Sie Ihre E-Mail-Adresse ein."
  validates_format_of :email, :with => /(^$|^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$)/i, :message => "Bitte geben Sie eine g&uuml;ltige E-Mail-Adresse ein."
end
