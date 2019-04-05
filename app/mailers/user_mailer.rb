class UserMailer < ApplicationMailer
  def registration_invite(ticket)
    @ticket = ticket
    mail(to: @ticket.email, subject: ENV['EMAIL_FROM_NAME'])
  end
end
