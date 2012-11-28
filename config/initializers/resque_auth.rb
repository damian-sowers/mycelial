Resque::Server.use(Rack::Auth::Basic) do |user, password|
	user = ENV['RESQUE_USER']
  password == ENV['RESQUE_PASSWORD']
end