require "resque/tasks"

#load rails environment when the workers start up. Will give your workers access to all models. To make this lighter only load specific things - look into this later.
task "resque:setup" => :environment 