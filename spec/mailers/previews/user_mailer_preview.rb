# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  def registration_invite
    ticket = Ticket.new(email: 'sparkle_pony@kiezburn.org')
    UserMailer.registration_invite(ticket)
  end
end
