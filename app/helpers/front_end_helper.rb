module FrontEndHelper

  def getIconPath(seat)
    return getStatusString(seat) + ".png"
  end

  def getStatusString(seat)
    if not @selectedSeats.nil? and @selectedSeats.include?(seat)
      return "selected"
    else
      case seat.status
        when 0
          return "unoccupied"
        when 1
          return "reserved"
        when 2
          return "occupied"

      end
    end
  end

end


