class LikeMailer
	@queue = :like_mailer_queue

	def self.perform(like_id)
		#fetch the record
		@like = Like.find(like_id)
		#need to get the email of the owner of the project
		@user_email = Project.find(@like.project_id).page.user.email
		#send email
		NotificationMailer.send_like_notification(@like, @user_email).deliver
	end	
end