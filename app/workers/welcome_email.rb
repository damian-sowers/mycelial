class WelcomeEmail
	@queue = :welcome_email_queue

	def self.perform(user_id)
		#fetch the user's email from the db
		user_email = User.find(user_id).email
		Welcome.send_welcome_email(user_email).deliver
	end	
end