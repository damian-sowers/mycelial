require 'resque/plugins/heroku'

class LikeNotifier
	extend Resque::Plugins::Heroku
	@queue = :likes_queue

	def self.perform(user_id)
		data = {'message' => 'New Notification'}
		Pusher['private-' + user_id.to_s].trigger('new_notification', data)
	end	
end