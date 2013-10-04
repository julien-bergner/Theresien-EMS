#encoding: utf-8

#######################################
#                                     #
#   Order Status:                     #
#   1. CREATED                        #
#   2. OPEN                           #
#   3. ORDER_CONFIRMATION_SEND        #
#   4. PAID                           #
#   5. RECEIPT_OF_PAYMENT_SEND        #
#   6. TICKETS_SEND                   #
#   7. COMPLETED                      #
#                                     #
#######################################

class Order < ActiveRecord::Base
  attr_accessible :amount, :customer_id, :delivery_method, :status
  has_many :seats
  belongs_to :customer
  accepts_nested_attributes_for :seats

  scope :created,                   :conditions => { :status => "CREATED" }
  scope :in_progress,               :conditions => { :status => "IN-PROGRESS" }
  scope :order_confirmation_send,   :conditions => { :status => "ORDER_CONFIRMATION_SEND" }
  scope :paid,                      :conditions => { :status => "PAID" }
  scope :receipt_of_payment_send,   :conditions => { :status => "RECEIPT_OF_PAYMENT_SEND" }
  scope :tickets_send,              :conditions => { :status => "TICKETS_SEND" }
  scope :completed,                 :conditions => {  :status => "COMPLETED" }
  scope :incomplete,                :conditions => ["status != 'COMPLETED'"]

  FILTERS = [
      {:scope => "all",                     :label => "Alle"},
      {:scope => "incomplete",              :label => "Offen"},
      {:scope => "completed",               :label => "Abgeschlossen"},
      {:scope => "created",                 :label => "Angelegt"},
      {:scope => "in_progress",             :label => "Aktiviert"},
      {:scope => "order_confirmation_send", :label => "Bestellbestätigung gesendet"},
      {:scope => "paid",                    :label => "Bezahlt"},
      {:scope => "receipt_of_payment_send", :label => "Zahlungsbeleg gesendet"},
      {:scope => "tickets_send",            :label => "Karten versendet"}
  ]

  def paypal_url(return_url)

    values = {
        :business => 'theresienball@theresienschule.de',
        :cmd => '_cart',
        :upload => 1,
        :return => return_url,
        :invoice => id
    }
    prepareDataForSelectionViewer()

    @displayedRows.each_with_index do |item, index|
      values.merge!({
                        "amount_#{index+1}" => item[0],
                        "item_name_#{index+1}" => item[1],
                       # "item_number_#{index+1}" => @order.id,
                        "quantity_#{index+1}" => item[2]

                    })
    end
    values.merge! ({"currency_code" => "EUR"})
    return "https://www.paypal.com/cgi-bin/webscr?" + values.to_query
  end

  def clean
    # Remove not completed and outdated orders
    Order.all.each { |o|
      if (o.created_at < Time.now - 10*60) && (o.customer_id.nil?)
        o.delete
      end
      }
  end

  def prepareDataForSelectionViewer()
    @order = self

    @seats = Seat.find_all_by_order_id(@order.id)

    @numberOfSeatsPerTable = Hash.new
    PromTable.all.each do |t|
      @numberOfSeatsPerTable[t.id] = 0
    end

    @seats.each do |seat|
      @numberOfSeatsPerTable[seat.prom_table_id] = @numberOfSeatsPerTable[seat.prom_table_id] + 1

    end

    @displayedRows = Array.new
    @overallAmount = 0

    @numberOfSeatsPerTable.each_key do |k|
      unless @numberOfSeatsPerTable.fetch(k) == 0
        numberOfSeats = @numberOfSeatsPerTable.fetch(k)
        promTable = PromTable.find_by_id(k)
        randomSeat = Seat.find_all_by_prom_table_id(k).pop()

        price = randomSeat.price
        cache = Array.new
        cache.push(getPricePerSeat(numberOfSeats, randomSeat))
        cache.push(getNumberOfSeatsString(numberOfSeats, promTable) + " " + getTableString(promTable))
        cache.push(numberOfSeats)

        @displayedRows.push(cache)


      end
    end

  end

  def getNumberOfSeatsString(numberOfSeats, promTable)
    return " #{numberOfSeats} #{promTable.seat_description}" + pluralizeSeatString(numberOfSeats)
  end

  def getTableString(promTable)
    if promTable.id == 1
      return ""
    else
      return "an " + promTable.caption
    end
  end

  def pluralizeSeatString(numberOfSeats)
    if numberOfSeats > 1
      return "n"
    else
      return ""
    end
  end

  def getPricePerSeat(numberOfSeats, randomSeat)
    if numberOfSeats == 10
      return "#{truncateFloatIfIsWholeNumber(randomSeat.prom_table.price/10)}".html_safe
    else
      return "#{truncateFloatIfIsWholeNumber(randomSeat.price)}".html_safe
    end

  end

  def getPriceString(price)
    return  "#{price}".html_safe
  end

  def getPrice(numberOfSeats, price, promTable)
    if numberOfSeats == 10
      return truncateFloatIfIsWholeNumber(promTable.price)
    else
      return numberOfSeats * truncateFloatIfIsWholeNumber(price)
    end
  end

  def truncateFloatIfIsWholeNumber(number)
    if number.modulo(1) == 0
      number = number.to_int
    end
    return number
  end

  def getSeatsPerTable
    seatsPerTable = Hash.new
    self.seats.each do |seat|
      table = seat.prom_table
      seatsPerTable[table] ||= Array.new
      seatsPerTable[table].push(seat)
    end
    return seatsPerTable
  end

  def statusIsMoreProceeded?(status)
    statusHash = Hash.new
    statusHash.store("CREATED", 1)
    statusHash.store("IN-PROGRESS", 2)
    statusHash.store("ORDER_CONFIRMATION_SEND", 3)
    statusHash.store("PAID", 4)
    statusHash.store("RECEIPT_OF_PAYMENT_SEND", 5)
    statusHash.store("TICKETS_SEND", 6)
    statusHash.store("COMPLETED", 7)
    i1 = statusHash.fetch(self.status)
    i2 = statusHash.fetch(status)
    if i1 >= i2
      return true
    else
      return false
    end
  end

  def statusIsNext?(status)
    statusHash = Hash.new
    statusHash.store("CREATED", 1)
    statusHash.store("IN-PROGRESS", 2)
    statusHash.store("ORDER_CONFIRMATION_SEND", 3)
    statusHash.store("PAID", 4)
    statusHash.store("RECEIPT_OF_PAYMENT_SEND", 5)
    statusHash.store("TICKETS_SEND", 6)
    statusHash.store("COMPLETED", 7)
    i1 = statusHash.fetch(self.status)
    i2 = statusHash.fetch(status)
    if i2 - i1 == 1
      return true
    else
      return false
    end
  end

  def markAsPaid

    self.status = "PAID"
    self.save


    self.seats.each { |s|
      s.status = 2
      s.save
    }

    sendReceiptOfPayment()
    sendTickets()
    markAsCompleted()

  end

  def sendOrderConfirmation

    OrderMailer.order_confirmation(self).deliver
    self.status = "ORDER_CONFIRMATION_SEND"
    self.save

  end

  def skipOrderConfirmation

    self.status = "ORDER_CONFIRMATION_SEND"
    self.save

  end

  def sendReceiptOfPayment

    OrderMailer.receipt_of_payment(self).deliver
    self.status = "RECEIPT_OF_PAYMENT_SEND"
    self.save

  end

  def sendTickets

    OrderMailer.tickets(self).deliver
    self.status = "TICKETS_SEND"
    self.save

  end

  def markAsCompleted

    self.status = "COMPLETED"
    self.save

  end

  def getTextForPDFGeneration

    ActionView::Base.new(Rails.configuration.paths["app/views"].first).render(
        :partial => 'orders/ticket', :format => :html,
        :locals => { :order => self, :customer => self.customer, :seats => self.seats}

    )


  end



end
