class UserObserver < ActiveRecord::Observer
  def after_create(model)
    r = Page.new
    r.name = "Your Name"
    r.user_id = model.id
    r.save
  end
end
