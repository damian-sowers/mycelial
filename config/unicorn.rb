worker_processes 3 # amount of unicorn workers to spin up
timeout 30         # restarts workers that hang for 30 seconds
preload_app true # need this for newrelic

#trying to get rid of pgerror:EOF detected. http://stackoverflow.com/questions/8497039/on-heroku-cedar-with-unicorn-getting-activerecordstatementinvalid-pgerror
after_fork do |server, worker|
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.establish_connection 
  end
end