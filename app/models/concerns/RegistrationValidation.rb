module RegistrationValidation
 extend ActiveSupport::Concern

  included do
    if Rails.configuration.x.firestarter_settings["registration_requires_ticket_with_matching_email"]
      validate :invite_code_valid, :on => :create
    end
  end

  def invite_code_valid
    self.email = self.email.downcase
    invite_code_local_tickets_valid()
    # Check if ticket exists in the local database to prevent going to remote server
    ticket = Ticket.find_by(id_code: self.ticket_id, email: self.email)

    if ticket.present?
      return
    end
  end

  def invite_code_local_tickets_valid
    unless Ticket.exists?(email: self.email)
      self.errors.add(:ticket_id, I18n.t(:invalid_membership_code))
      return
    end
    if User.exists?(email: self.email)
      self.errors.add(:ticket_id, I18n.t(:membership_code_registered))
      return
    end
  end
end


