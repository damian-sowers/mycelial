worker_processes 4 # amount of unicorn workers to spin up
timeout 50         # restarts workers that hang for 30 seconds
preload_app true # need this for newrelic