require 'resque/plugins/heroku'

class NotificationChanger
  extend Resque::Plugins::Heroku
  @queue = :notifications_queue

  def self.perform(new_ids)
    new_ids.each do |x|
      notification = Notification.find(x)
      notification.update_attribute(:viewed, 1) 
    end
  end 
end