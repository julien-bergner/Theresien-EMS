module FrontEndHelper

  def getIconPath(status)
    case status
      when 0
        return getStatusString(status) + ".png"
      when 1
        return getStatusString(status) + ".png"
      when 2
        return getStatusString(status) + ".png"

    end
  end

  def getStatusString(status)
    case status
      when 0
        return "unoccupied"
      when 1
        return "reserved"
      when 2
        return "occupied"

      end
    end

end


