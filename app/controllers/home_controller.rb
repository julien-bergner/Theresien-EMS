class HomeController < ApplicationController
  respond_to :html, :js
  def index

  end

  def booking
    respond_to do |format|
      format.html

      end


  end
end
