class Notification < ActiveRecord::Base

  belongs_to :user

  after_create :send_to_user

  def self.unread_notifications(user_id)
    where(["user_id = ? and is_read is false", user_id])
  end

  def self.readed_notifications(user_id)
    where(["user_id = ? and is_read is true", user_id])
  end

  def self.types
    {
      :purchase => 0,
      :ration => 1,
      :order => 2
    }
  end

  protected

  def send_to_user
    # $publish_redis.publish("notification_#{self.user_id}", "update_natification_count")
  end

end
