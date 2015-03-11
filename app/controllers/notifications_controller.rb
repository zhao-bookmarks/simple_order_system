class NotificationsController < ApplicationController

  before_filter :login_required

  def index
    @unread_notifitions = Notification.unread_notifications(current_user.id)
    @readed_notifitions = Notification.readed_notifications(current_user.id)
  end

  def read
    @notification = Notification.find(params[:id])
    @notification.update_attribute(:is_read, true)
  end

  def update_count
    render :text => current_user.unread_notifications_count
  end
end
