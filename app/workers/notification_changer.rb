class NotificationChanger
	@queue = :notifications_queue

	def self.perform(new_ids)
		new_ids.each do |x|
			notification = Notification.find(x)
			notification.update_attribute(:viewed, 1)	
		end
	end	
end