# to import run bundle exec rake import_burnertickets

require 'rest-client'
require 'json'

desc "Import Ticket from tickets events url"
task :import_burnertickets => [:environment] do
  ['TICKETS_EVENT_URL', 'BURNER_TICKETS_EVENT_ID', 'BURNER_TICKETS_API_KEY'].each do |key|
    if(ENV[key].nil?)
      puts "Error: Please set env #{key}"
    end
  end

  BurnerTicketsImporter.new(
    ENV['TICKETS_EVENT_URL'],
    ENV['BURNER_TICKETS_EVENT_ID'],
    ENV['BURNER_TICKETS_API_KEY']
  ).import
end