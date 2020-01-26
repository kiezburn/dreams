class BurnerTicketsImporter
  API_URL = 'https://burnertickets.com/BurnerTicketing/API/'

  def initialize(event_id, api_key)
    @event_id = event_id
    @api_key = api_key
  end

  def call 
    burnerTickets = get_ticket_data
    counter = 0
    ignoredCounter = 0
    updatedCounter = 0
    print_debug("Found #{burnerTickets.length} tickets")
    burnerTickets.each do |burnerTicket|

      email = burnerTicket["EmailAddress"].downcase
      ticket_id = burnerTicket["TicketNumber"]
      userId = burnerTicket["UserId"]

      unless Ticket.exists?(email: email)   # since one email may have many ticket (kids), check per email instead of ticket_id
        counter+=1
        ticket = Ticket.create(id_code: ticket_id, email: email)
        send_registration_invite(ticket)
        allocate_grants_to_existing_user(ticket)
        print_debug("Added Ticket(email: #{email}, BurnerTickets ID: #{userId}, ticket ID: #{ticket_id})")
      else
        unless Ticket.exists?(email: email)
          print_debug("Found ticket to transfer")
          ticket = Ticket.find_by(id_code: ticket_id)
          ticket.update(email: email)
          print_debug("Transferred ticket #{ticket_id} to #{email}")
          updatedCounter+=1
        else
          ignoredCounter+=1
        end
      end
    end

    print_debug("Added #{counter} Tickets to our database")
    print_debug("Found #{ignoredCounter} Tickets that are already in the database")
    print_debug("Transferred #{updatedCounter} Tickets to new burners")
  end

  private

  def allocate_grants_to_existing_user(ticket)
    existing_user = User.find_by(email: ticket.email)
    unless existing_user.nil? || existing_user.grants > 0
      existing_user.grants = ENV['DEFAULT_HEARTS'] || 10
      existing_user.save
      print_debug("Allocated #{existing_user.grants} grants to #{ticket.email}")
    end
  end

  def send_registration_invite(ticket)
    return if User.find_by(email: ticket.email)
    print_debug("sending mail to #{ticket.email}")
    UserMailer.registration_invite(ticket).deliver_now
  end

  def get_ticket_data
    response = RestClient.post(API_URL, {'method' => 'GetUsersWithTicketsEventId', 'eventId' => @event_id, 'apiKey' => @api_key})
    parsedResponse = JSON.parse(response.body)["message"]
  end

  def print_debug(message)
    puts message unless Rails.env.test?
  end
end