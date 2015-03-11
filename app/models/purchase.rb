class Purchase < ActiveRecord::Base

  belongs_to :user
  has_many :purchase_records
  accepts_nested_attributes_for :purchase_records, :allow_destroy => true
  has_many :products, :through => :purchase_records

  after_create :update_orders_and_products
  after_create :create_notifications

  protected

  def update_orders_and_products
    # 更新库存数量
    self.change_warehouse_count

    # 更新 orders 状态
    Order.not_rationed.each do |order|
      order.count_elements
    end

    # 更新 product 状态
    self.products.each do |product|
      product.count_orders
    end
  end

  def change_warehouse_count
    self.purchase_records.each do |record|
      record.product.update_attribute(:store, record.product.store + record.product_count * record.unit.rate)
    end
  end

  def create_notifications
    User.all.each do |user|
      Notification.create({
        :user_id => user.id,
        :type_id => Notification.types[:purchase],
        :target_id => self.id,
        :content => "进货",
        :is_read => false
      })
    end
  end
  
end
