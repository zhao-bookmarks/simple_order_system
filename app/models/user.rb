class User < ActiveRecord::Base

  has_many :orders
  has_many :warehouse_records
  has_many :purchases
  has_many :notifications

  validates :login, :presence => true, :uniqueness => true # {:case_sensitive => false}
  
  has_secure_password
  validates :password, :length => {:minimum => 6, :allow_blank => true}

  def self.roles
    {
      :super_admin => 1,
      :admin => 2,
      :warehouse => 3,
      :order => 4
    }
  end

  self.roles.each do |role_name, role_id|
    define_method "#{role_name}?".to_sym do
      self.role_id == role_id
    end
  end

  def role
    self.class.roles.each do |role_name, role_id|
      return role_name if self.role_id == role_id
    end
  end

  def real_name
    self.name.present? ? self.name : self.login
  end

  def unread_notifications_count
    count = Notification.unread_notifications(self.id).count
    count > 0 ? count : ""
  end

end
