# to import run bundle exec rake import_burnertickets

require 'rest-client'
require 'json'

desc "Import Tickets from burnertickets (set env variables BURNER_TICKETS_EVENT_ID and BURNER_TICKETS_API_KEY)"
task :import_burnertickets => [:environment] do
  ['BURNER_TICKETS_EVENT_ID', 'BURNER_TICKETS_API_KEY'].each do |key|
    if(ENV[key].nil?)
      puts "Error: Please set env #{key}"
    end
  end

  BurnerTicketsImporter.new(
    ENV['BURNER_TICKETS_EVENT_ID'],
    ENV['BURNER_TICKETS_API_KEY']
  ).import
end