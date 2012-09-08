#encoding: utf-8

class CustomersController < ApplicationController
  before_filter :authenticate_admin!

  # GET /customers
  # GET /customers.json
  def index
    @customers = Customer.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @customers }
    end
  end

  # GET /customers/1
  # GET /customers/1.json
  def show
    prepareDataForSelectionViewer()
    @customer = Customer.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @customer }
    end
  end

  # GET /customers/new
  # GET /customers/new.json
  def new
    prepareDataForSelectionViewer()

    @customer = Customer.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @customer }
    end
  end

  # GET /customers/1/edit
  def edit
    prepareDataForSelectionViewer()
    @customer = Customer.find(params[:id])
  end

  # POST /customers
  # POST /customers.json
  def create

    prepareDataForSelectionViewer()

    @customer = Customer.new(params[:customer])

    respond_to do |format|
      if @customer.save
        format.html { redirect_to @customer, notice: 'Customer was successfully created.' }
        format.json { render json: @customer, status: :created, location: @customer }
      else
        format.html { render action: "new" }
        format.json { render json: @customer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /customers/1
  # PUT /customers/1.json
  def update
    prepareDataForSelectionViewer()
    @customer = Customer.find(params[:id])

    respond_to do |format|
      if @customer.update_attributes(params[:customer])
        format.html { redirect_to @customer, notice: 'Customer was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @customer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /customers/1
  # DELETE /customers/1.json
  def destroy
    @customer = Customer.find(params[:id])
    @customer.destroy

    respond_to do |format|
      format.html { redirect_to customers_url }
      format.json { head :no_content }
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



end
