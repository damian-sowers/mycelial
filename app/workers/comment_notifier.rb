class CommentNotifier
	@queue = :comments_queue

	def self.perform(user_id)
		data = {'message' => 'New Notification'}
		Pusher['private-' + user_id.to_s].trigger('new_comment', data)
	end	
end