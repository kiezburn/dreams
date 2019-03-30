class UserMailer < ApplicationMailer
  def registration_invite(ticket)
    @ticket = ticket
    mail(to: @ticket.email, subject: 'Register for dreams')
  end
end
