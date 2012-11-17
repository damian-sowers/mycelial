class NotifyObserver < ActiveRecord::Observer
	observe :comment
 
  def after_create(model)
    r = Notification.new
    r.sender_id = 1
    r.receiver_id = 2
    r.notification_id = 100
    r.notification_type = "comment"
    r.save
  end
end
