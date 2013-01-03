require "resque/tasks"

#load rails environment when the workers start up. Will give your workers access to all models. To make this lighter only load specific things - look into this later.
task "resque:setup" => :environment do 
	ENV['QUEUE'] = '*'
	ENV['RESQUE_TERM_TIMEOUT'] = 15
	ENV['TERM_CHILD'] = 1
  Resque.before_fork = Proc.new { ActiveRecord::Base.establish_connection }
end