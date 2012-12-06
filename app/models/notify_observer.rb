class NotifyObserver < ActiveRecord::Observer
  observe :comment, :like

  def after_create(model)
    r = Notification.new
    r.sender_id = model.user_id
    r.receiver_id = Project.find(model.project_id).page.user.id
    r.notification_id = model.id
    #put in an if statement to see if model is comment or like
    if model.methods.include?(:comment)
      r.notification_type = "comment"
    else
      r.notification_type = "like"
      increment_likes_count(model)
    end
    r.viewed = 0
    r.save
  end

  def increment_likes_count(model)
    r = Project.find(model.project_id)
    r.likes_count ||= 0
    r.likes_count = r.likes_count + 1
    r.save
  end
end
