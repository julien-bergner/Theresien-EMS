class OrdersController < ApplicationController
  before_filter :authenticate_admin!

  # GET /orders
  # GET /orders.json
  def index
    @filters = Order::FILTERS
    if params[:show] && @filters.collect{|f| f[:scope]}.include?(params[:show])
      @orders = Order.send(params[:show])
    else
      @orders = Order.all
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @orders }
    end
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
    @order = Order.find(params[:id])

    respond_to do |format|
      format.html # showSummary.html.erb
      format.json { render json: @order }
    end
  end

  # GET /orders/new
  # GET /orders/new.json
  def new
    @order = Order.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @order }
    end
  end

  # GET /orders/1/edit
  def edit
    @order = Order.find(params[:id])
  end

  # POST /orders
  # POST /orders.json
  def create
    @order = Order.new(params[:order])

    respond_to do |format|
      if @order.save
        format.html { redirect_to @order, notice: 'Order was successfully created.' }
        format.json { render json: @order, status: :created, location: @order }
      else
        format.html { render action: "new" }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /orders/1
  # PUT /orders/1.json
  def update
    @order = Order.find(params[:id])

    respond_to do |format|
      if @order.update_attributes(params[:order])
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order = Order.find(params[:id])
    releaseSeats(@order)
    @order.destroy

    respond_to do |format|
      format.html { redirect_to orders_url }
      format.json { head :no_content }
    end
  end

  def markAsPaid
    @order = Order.find(params[:id])
    @order.markAsPaid
    redirect_to customers_path(:anchor => "customer_#{@order.customer_id}")
  end

  def sendOrderConfirmation
    @order = Order.find(params[:id])
    @order.sendOrderConfirmation
    redirect_to customers_path(:anchor => "customer_#{@order.customer_id}")
  end

  def skipOrderConfirmation
    @order = Order.find(params[:id])
    @order.skipOrderConfirmation
    redirect_to customers_path(:anchor => "customer_#{@order.customer_id}")
  end

  def sendReceiptOfPayment
    @order = Order.find(params[:id])
    @order.sendReceiptOfPayment
    redirect_to customers_path(:anchor => "customer_#{@order.customer_id}")
  end

  def sendTickets
    @order = Order.find(params[:id])
    @order.sendTickets

    redirect_to customers_path(:anchor => "customer_#{@order.customer_id}")
  end

  def releaseSeats(order)

    @order = order

    Seat.find_all_by_order_id(@order.id).each do |seat|
      seat.order_id = nil
      seat.status = 0
      seat.save
    end
  end

  def sendTicketPDFToBrowser
    @order = Order.find(params[:id])
    send_data(WickedPdf.new.pdf_from_string(@order.getTextForPDFGeneration()),
              :filename => "Theresienballkarten-#{Date.today.year}-#{@order.customer.first_name}-#{@order.customer.last_name}.pdf", :type => "pdf"
    )
  end

end
