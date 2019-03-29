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
    puts "Found " + burnerTickets.length.to_s + " tickets"
    burnerTickets.each do |burnerTicket|

      email = burnerTicket["EmailAddress"].downcase
      ticket_id = burnerTicket["TicketNumber"]
      userId = burnerTicket["UserId"]

      unless Ticket.exists?(id_code: ticket_id)
        counter+=1
        Ticket.create(id_code: ticket_id, email: email.downcase)
        puts "Added email: #{email}, BurnerTickets ID: #{userId}, ticket ID: #{ticket_id}" 
      else
        unless Ticket.exists?(email: email)
          puts "Found ticket to transfer"
          ticket = Ticket.find_by(id_code: ticket_id)
          ticket.update(email: email)
          puts "Transferred ticket" + ticket_id + " to " + email
          updatedCounter+=1
        else
          ignoredCounter+=1
        end
      end
    end
    
    puts "Added " + counter.to_s + " Tickets to our database"
    puts "Found " + ignoredCounter.to_s + " Tickets that are already in the database"
    puts "Transferred " + updatedCounter.to_s + " Tickets to new burners"
  end

  private

  def get_ticket_data
    begin
      response = RestClient.post(API_URL, {'method' => 'GetUsersWithTicketsEventId', 'eventId' => @event_id, 'apiKey' => @api_key})
      parsedResponse = JSON.parse(response.body)
    rescue SocketError => e
      puts e.message
    end
    parsedResponse["message"]
  end 
end