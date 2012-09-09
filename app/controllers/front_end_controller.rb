#encoding: utf-8
class FrontEndController < ApplicationController

  respond_to :html

  def index

  end

  def booking
    @order = Order.find_by_id(session[:order_id])
    if not @order.nil?
      @selectedSeats = Seat.find_all_by_order_id(@order.id)
      prepareDataForSelectionViewer()

    end

    @table_and_seat_data = Hash.new

    @prom_tables = PromTable.all
    for prom_table in @prom_tables do
      seats_at_table = Seat.find_all_by_prom_table_id(prom_table.id)
      @table_and_seat_data.store(prom_table, seats_at_table)
    end
  end

  def receiveSelectedSeats
    selectedSeatsString = params[:selectedSeatsList];
    selectedSeats = selectedSeatsString.split(',');

    @order = Order.find_by_id(session[:order_id])
    if @order.nil?
      @order = Order.create
      session[:order_id] = @order.id
    end

    Seat.find_all_by_id(selectedSeats).each do |seat|
      seat.order_id = @order.id
      seat.status = 1
      seat.save
    end


    redirect_to :newCustomer


  end

  def newCustomer
    prepareDataForSelectionViewer()

    @customer = Customer.new

    respond_to do |format|
      format.html # newCustomer.html.erb

    end
  end

  def createCustomer

    prepareDataForSelectionViewer()

    @customer = Customer.new(params[:customer])

    respond_to do |format|
      if @customer.save
        session[:customer_id] = @customer.id
        format.html { redirect_to :showSummary }

      else
        format.html { render action: "newCustomer" }

      end
    end
  end

  def showSummary
    prepareDataForSelectionViewer()
    @customer = Customer.find(session[:customer_id])

    respond_to do |format|
      format.html # showSummary.html.erb
      format.json { render json: @customer }
    end
  end

  def editCustomer
    prepareDataForSelectionViewer()
    @customer = Customer.find(session[:customer_id])
  end

  def updateCustomer
    prepareDataForSelectionViewer()
    @customer = Customer.find(session[:customer_id])

    respond_to do |format|
      if @customer.update_attributes(params[:customer])
        format.html { redirect_to :showSummary, notice: 'Customer was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "editCustomer" }
        format.json { render json: @customer.errors, status: :unprocessable_entity }
      end
    end
  end

  def prepareDataForSelectionViewer()
    @order = Order.find_by_id(session[:order_id])

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
        cache.push(getNumberOfSeatsString(numberOfSeats, promTable))
        cache.push(getTableString(promTable))
        cache.push(getPerSeatString(numberOfSeats, randomSeat))
        cache.push(getPriceString(getPrice(numberOfSeats, price, promTable)))

        @displayedRows.push(cache)

        @overallAmount += getPrice(numberOfSeats, price, promTable)
      end
    end

    @displayedRows.push(getOverallPriceRow(@overallAmount))

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

  def getPerSeatString(numberOfSeats, randomSeat)
    if numberOfSeats == 10
      return ""
    else
      return "à #{truncateFloatIfIsWholeNumber(randomSeat.price)} &euro;".html_safe
    end

  end

  def getPriceString(price)
    return  " = #{price} &euro;".html_safe
  end

  def getPrice(numberOfSeats, price, promTable)
    if numberOfSeats == 10
      return truncateFloatIfIsWholeNumber(promTable.price)
    else
      return numberOfSeats * truncateFloatIfIsWholeNumber(price)
    end
  end

  def truncateFloatIfIsWholeNumber(number)
    if number.modulo(2) == 0 or number.modulo(2) == 1
      number = number.truncate()
    end
    return number
  end

  def getOverallPriceRow(overallAmount)
    Array["","", "Gesamt", " = #{overallAmount} &euro;".html_safe]
  end

  def photos

  end

  def sponsors

  end

  def contact

  end

  def legal

  end

end
