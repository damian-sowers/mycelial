class NotificationsController < ApplicationController
	include Mycelial

	before_filter :authenticate_user!, except: [:show, :index]
	# before_filter :correct_user, only: [:update]
	# before_filter :owner_of_page?, only: [:destroy]
	before_filter :get_sidebar_info

	def index
		#show all new notifications for the logged in user. 
		notifications = Notification.find_all_by_receiver_id(current_user.id)

		@comment_notifications = []
		notifications.each do |f| 
			#need to build up a new object of all the comments.  
			if f.notification_type == "comment"
				#query comments table for the comment with this notification_id
				n = Comment.find(f.notification_id)
				@comment_notifications << n
			end
		end
	end
end
