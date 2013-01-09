desc "This task is called by the Heroku cron add-on"
task :call_page => :environment do
  uri = URI.parse('http://www.mycelial.com')
  Net::HTTP.get(uri)
end