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
  helper MailerHelper

  default from: "theresienball@theresienschule.de"
  default bcc:  "theresienball@theresienschule.de"



  def order_confirmation(order)
    attachments.inline['logo.png'] = File.read('app/assets/images/logo.png')
    @order = order
    @customer = order.customer
    #@customer = Customer.find(@order.customer_id)

    mail(:to => @customer.email, :subject => "Buchungsbestätigung Theresienball #{Date.today.year}")
  end

  def receipt_of_payment(order)
    attachments.inline['logo.png'] = File.read('app/assets/images/logo.png')
    @order = order
    @customer = order.customer
    #@customer = Customer.find(@order.customer_id)

    mail(:to => @customer.email, :subject => "Eingang Ihrer Zahlung für den Theresienball #{Date.today.year}")
  end

  def tickets(order)

    attachments.inline['logo.png'] = File.read('app/assets/images/logo.png')

    @order = order
    @customer = order.customer

    #if Rails.env.production? then isTest = false else isTest = true end
    isTest = true
    attachments['Theresienball-Karten.pdf'] = DocRaptor.create(:document_content => @order.getTextForPDFGeneration(), :document_type => "pdf", :name => "Order_#{@order.id}", :test => isTest).body

    mail(:to => @customer.email, :subject => "Ihre Karten für den Theresienball #{Date.today.year}")

  end

end
