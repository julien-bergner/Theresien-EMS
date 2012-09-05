class FrontEndController < ApplicationController

  respond_to :html

  def index

  end

  def booking
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


    redirect_to(new_customer_path)


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
