module MailerHelper

  def testw(number)
    if number.modulo(1) == 0
      number = number.to_int
    end
    return number
  end

end