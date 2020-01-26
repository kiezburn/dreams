class UserMailer < ApplicationMailer
  def registration_invite(ticket)
    @ticket = ticket
    mail(to: @ticket.email, subject: ENV['EMAIL_SUBJECT'])
  end
end
