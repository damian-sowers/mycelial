class NotifyObserver < ActiveRecord::Observer
	observe :comment
 
  def after_create(model)
    r = Notification.new
    r.sender_id = model.user_id
    r.receiver_id = Project.find(model.project_id).page.user.id
    r.notification_id = model.id
    #put in an if statement to see if model is comment or like
    r.notification_type = "comment"
    r.save
  end
end
