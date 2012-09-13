#encoding: utf-8

##############################################################################
#                                                                           #
#  Find the views for this mail in app/views/order_mailer                    #
#  To deliver a mail, invoke e.g.                                            #
#       OrderMailer.order_confirmation(Customer.first).deliver               #
#  in the right place ;)                                                     #
#                                                                            #
##############################################################################

class OrderMailer < ActionMailer::Base
  default from: "theresienball@theresienschule.de"

  def order_confirmation(customer, order)
    @customer = customer
    @order = order
    mail(:to => customer.email, :subject => "Buchungsbestätigung Theresienball #{Date.today.year}")
  end
end
