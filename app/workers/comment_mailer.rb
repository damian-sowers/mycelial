class CommentMailer
	@queue = :comment_mailer_queue

	def self.perform(comment_id)
		#fetch the record
		@comment = Comment.find(comment_id)
		#need to get the email of the owner of the project
		@user_email = Project.find(@comment.project_id).page.user.email
		#send email
		NotificationMailer.send_comment_notification(@comment, @user_email).deliver
	end	
end