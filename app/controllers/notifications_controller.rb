class NotificationsController < ApplicationController
	include Mycelial

	before_filter :authenticate_user!
	# before_filter :correct_user, only: [:update]
	# before_filter :owner_of_page?, only: [:destroy]
	before_filter :get_sidebar_info

	def index
		#show all new notifications for the logged in user. 
		new_notifications = Notification.get_new_notifications(current_user.id)

		@new_notifications = []
		new_notifications.each do |f| 
			#need to build up a new object of all the comments.  
			if f.notification_type == "comment"
				#query comments table for the comment with this notification_id
				n = Comment.find(f.notification_id)
				@new_notifications << n
			end
		end
	end

	def old
		#get all notifications. Paginate the results
		@old_notifications = []
		all_notifications = Notification.where("receiver_id = ?", current_user.id).order("created_at DESC")

		notifications_per_page = 3

		@total_pages = (all_notifications.count.to_f / notifications_per_page.to_f).ceil
		params[:page] ||= 1
		i = 1

		all_notifications.each do |f| 
			#for paginating the notifications 
			if i <= (notifications_per_page * params[:page].to_i) && i > (notifications_per_page * (params[:page].to_i - 1))

				if f.notification_type == "comment"
					#query comments table for the comment with this notification_id
					n = Comment.find(f.notification_id)
					@old_notifications << n
				end

				if f.notification_type == "like"
					#query the likes table for the notification.
				end

			end
			i += 1
		end
		
		render 'all_notifications'
	end
end
