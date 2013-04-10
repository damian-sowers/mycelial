require 'resque/plugins/heroku'

class CommentNotifier
  extend Resque::Plugins::Heroku
  @queue = :comments_queue

  def self.perform(user_id)
    data = {'message' => 'New Notification'}
    Pusher['private-' + user_id.to_s].trigger('new_notification', data)
  end 
end