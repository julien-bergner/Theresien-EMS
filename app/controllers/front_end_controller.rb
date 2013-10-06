#encoding: utf-8
class FrontEndController < ApplicationController

  respond_to :html

  def index

  end

  def switchCustomer
    if session[:customer_id].nil?
      redirect_to :newCustomer
    else
      redirect_to :editCustomer, :id => session[:customer_id]
    end
  end

  def booking
    @order = Order.find_by_id(session[:order_id])
    unless @order.nil?
      @selectedSeats = Seat.find_all_by_order_id(@order.id)
      prepareDataForSelectionViewer()
      @selectedSeatsIds = Array.new
      @selectedSeats.each { |seat| @selectedSeatsIds << seat.id }

    else
      @numberOfSeatsPerTable = Hash.new
      PromTable.all.each do |t|
        @numberOfSeatsPerTable[t.id] = 0
      end
    end



    @numberOfSeatsPerTableArray = Array.new

    @numberOfSeatsPerTable.sort{|a,b| a[0]<=>b[0]}.each do |x,y|
      @numberOfSeatsPerTableArray << y


    end

    @table_and_seat_data = Hash.new

    @prom_tables = PromTable.all
    for prom_table in @prom_tables do
      seats_at_table = Seat.find_all_by_prom_table_id(prom_table.id)
      # Select the first five Flanierkarten to be displayed
      if prom_table.seat_description == 'Flanierkarte'
        if session[:displayedPromenadeSeats].nil?
          cache = Array.new
          count = 1
          seats_at_table.each do |seat|
            if count <= 5
              if seat.status == 0
                count += 1
                cache << seat
              end
            else
              break
            end
          end
          session[:displayedPromenadeSeats] = cache
        end
        seats_at_table = session[:displayedPromenadeSeats]
      end
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

    Seat.find_all_by_order_id(@order.id).each do |seat|
      seat.order_id = nil
      seat.status = 0
      seat.save
    end

    Seat.find_all_by_id(selectedSeats).each do |seat|
      seat.order_id = @order.id
      seat.status = 1
      seat.save
    end

    redirect_to :switchCustomer
  end

  def newCustomer
    if session[:order_id].nil?
      redirect_to :root
      return
    end

    prepareDataForSelectionViewer()

    @customer = Customer.new

    respond_to do |format|
      format.html # newCustomer.html.erb
    end
  end

  def createCustomer
    if session[:order_id].nil?
      redirect_to :root
      return
    end
    prepareDataForSelectionViewer()

    if session[:customer_id].nil?
      @customer = Customer.new(params[:customer])
    else
      @customer = Customer.find(session[:customer_id])
    end

    @order = Order.find_by_id(session[:order_id])
    @order.customer = @customer
    t
    unless params[:order].nil?
      @order.delivery_method = params[:order][:delivery_method]
    end
    @order.save

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
    if session[:customer_id].nil?
      redirect_to :root
      return
    end
    prepareDataForSelectionViewer()
    @customer = Customer.find(session[:customer_id])

    respond_to do |format|
      format.html # showSummary.html.erb
      format.json { render json: @customer }
    end
  end

  def editCustomer
    if session[:customer_id].nil?
      redirect_to :root
      return
    end
    prepareDataForSelectionViewer()
    @customer = Customer.find(session[:customer_id])
  end

  def updateCustomer
    if session[:customer_id].nil?
      redirect_to :root
      return
    end

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
    @order.amount = getOverallPrice(@overallAmount)
    @order.save
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
      number = number.to_int
    end
    return number
  end

  def getOverallPrice(overallAmount)
    truncatedAmount = truncateFloatIfIsWholeNumber(overallAmount)

    if truncatedAmount.is_a?(Float)
      roundedAmount = truncatedAmount.round(2)
    else
      roundedAmount = truncatedAmount
    end
    return roundedAmount
  end

  def getOverallPriceRow(overallAmount)

    Array["","", "Gesamt", " = #{getOverallPrice(overallAmount)} &euro;".html_safe]
  end

  def cancel
    releaseSeats()
    releaseOrder()
    releaseCustomer()
    reset_session()
    redirect_to root_path
  end

  def releaseSeats()
    @order_id = session[:order_id]

    unless @order_id.nil?
      Seat.find_all_by_order_id(@order_id).each do |seat|
        seat.order_id = nil
        seat.status = 0
        seat.save
      end
    end

  end

  def releaseCustomer
    @customer_id = session[:customer_id]

    unless @customer_id.nil?
      @customer = Customer.find(@customer_id)
      @customer.destroy
    end
  end

  def releaseOrder
    @order_id = session[:order_id]

    unless @order_id.nil?
      @order = Order.find(@order_id)
      @order.destroy
    end

  end

  def payment
    if session[:order_id].nil?
      redirect_to :root
      return
    end

    @order = Order.find(session[:order_id])
    @order.status = "IN-PROGRESS"
    @amount = "#{getOverallPrice(@order.amount)} &euro;".html_safe
  end

  def goToPaypal
    if session[:order_id].nil?
      redirect_to :root
      return
    end
    @order = Order.find(session[:order_id])
    @order.skipOrderConfirmation
    reset_session

    redirect_to @order.paypal_url(Figaro.env.host + "/front_end/paypalReturn")


  end

  def paypalReturn

  end

  def bankData

    if session[:order_id].nil?
      redirect_to :root
      return
    end
    @order = Order.find(session[:order_id])

    @amount = "#{getOverallPrice(@order.amount)} &euro;".html_safe
    @order.sendOrderConfirmation
    reset_session
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
