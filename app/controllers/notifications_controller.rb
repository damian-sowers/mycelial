class NotificationsController < ApplicationController

	before_filter :authenticate_user!
	before_filter :get_sidebar_info

	def index
		@user = current_user
		#show all new notifications for the logged in user. 
		new_notifications = Notification.get_new_notifications(current_user.id)

		@new_notifications = []
		@new_ids = []

		new_notifications.each do |f| 
			#need to build up a new object of all the comments.  
			if f.notification_type == "comment"
				#query comments table for the comment with this notification_id
				begin
					n = Comment.find(f.notification_id)	
				rescue ActiveRecord::RecordNotFound => e
					n = nil
				end
				@new_notifications << n unless !n
			end

			if f.notification_type == "like"
				begin
					l = Like.find(f.notification_id)
				rescue ActiveRecord::RecordNotFound => e
					l = nil
				end
				@new_notifications << l unless !l
			
			end
			#now change the viewed column to 1 for these new notifications. Put this in a background worker. Build up array of ids to add to the worker.
			@new_ids << f.id
		end
		Resque.enqueue(NotificationChanger, @new_ids)

	end

	def old
		@user = current_user
		#get all notifications. Paginate the results
		@old_notifications = []
		all_notifications = Notification.where("receiver_id = ?", current_user.id).order("created_at DESC")

		notifications_per_page = 10

		@total_pages = (all_notifications.count.to_f / notifications_per_page.to_f).ceil
		params[:page] ||= 1
		i = 1

		all_notifications.each do |f| 
			#for paginating the notifications 
			if i <= (notifications_per_page * params[:page].to_i) && i > (notifications_per_page * (params[:page].to_i - 1))

				if f.notification_type == "comment"
					#query comments table for the comment with this notification_id
					begin
						n = Comment.find(f.notification_id)
					rescue ActiveRecord::RecordNotFound => e
						n = nil
					end
					@old_notifications << n unless !n
				end

				if f.notification_type == "like"
					#query the likes table for the notification.
					begin
						l = Like.find(f.notification_id)
					rescue ActiveRecord::RecordNotFound => e
						l = nil
					end
					@old_notifications << l unless !l
				end
			end
			i += 1
		end
		render 'all_notifications'
	end
end
