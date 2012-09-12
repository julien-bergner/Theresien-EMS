#encoding: utf-8

class Order < ActiveRecord::Base
  attr_accessible :amount, :customer_id, :delivery_method, :status
  has_many :seats
  belongs_to :customer
  accepts_nested_attributes_for :seats

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
      return "#{truncateFloatIfIsWholeNumber(25)}".html_safe
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




end
