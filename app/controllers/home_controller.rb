class HomeController < ApplicationController
  respond_to :html, :js
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

end
