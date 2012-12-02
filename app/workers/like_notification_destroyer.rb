class LikeNotificationDestroyer
	@queue = :like_notification_destroyer_queue

	def self.perform(like_id)
		#notification_id is equivalent to the like_id. 
		r = Notification.find_by_notification_id(like_id)
		if r 
			r.destroy 
		end
	end	
end