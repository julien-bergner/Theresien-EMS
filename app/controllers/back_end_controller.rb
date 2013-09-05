class BackEndController < ApplicationController
  before_filter :authenticate_admin!

  def overview
    @filters = Order::FILTERS
    @customers = Customer.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @customers }
    end

  end

end
