require 'rails_helper'
require 'faker'
I18n.reload!

describe BurnerTicketsImporter do
  let(:event_id) { 'kiezburn-2018'}
  let(:api_key) { '12345678'}

  let(:ticket_email) { 'steve@example.com' }
  let(:ticket_number) { '2222' }

  let(:example_json) do
    {
      message: [
        {
          EmailAddress: ticket_email,
          TicketNumber: ticket_number,
          UserId: '3333'
        }
      ]
    }.to_json
  end

  subject(:import) do 
    BurnerTicketsImporter.new(event_id, api_key).call
  end

  before { expect(RestClient).to receive(:post).and_return(double(body: example_json)) }

  context 'when there is no ticket with that email' do
    context 'when there is no user with that email' do
      it 'creates a ticket with that email and sends an invite' do    
        expect(UserMailer).to receive(:registration_invite).and_call_original
        expect{ import }.to change{ Ticket.count}.by(1)
        expect(Ticket.last.email).to eq(ticket_email)
        expect(Ticket.last.id_code).to eq(ticket_number)
      end
    end

    context 'when there is a user with that email' do
      let(:existing_user) { User.create(email: ticket_email, password: 'password', password_confirmation: 'password')}
      before { existing_user }

      it 'creates a ticket with that email, but does not send an invite' do    
        expect(UserMailer).not_to receive(:registration_invite)
        expect{ import }.to change{ Ticket.count}.by(1)
      end
    end
  end

  context 'when a ticket with that email already exists' do
    let(:existing_ticket) { Ticket.create(email: other_email, id_code: ticket_number)}
    let(:other_email) { 'sparkle_pony@example.com'}

    before{ existing_ticket }
    it 'modifies the existing ticket' do  
      expect{ import }.not_to change{ Ticket.count}
      expect(Ticket.last.email).to eq(ticket_email)
      expect(Ticket.last.id_code).to eq(ticket_number)
    end
  end

end