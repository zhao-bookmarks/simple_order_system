class Order < ActiveRecord::Base

  belongs_to :user
  has_many :line_items, :dependent => :destroy
  accepts_nested_attributes_for :line_items, :allow_destroy => true

  has_many :rations, :dependent => :destroy
  has_many :shipments, :dependent => :destroy
  has_many :products, :through => :line_items

  validates :number, :presence => true

  after_create :count_elements

  scope :not_rationed, -> {where(["element_status_id <> ?", Order.element_status[:rationed]])}

  def self.status
    {
      :begin => 0,
      :end => 1,
      :return => 2,
      :close => 3
    }
  end

  def self.element_status
    {
      :not_ration => 0,
      :rationing => 1,
      :rationed => 2
    }
  end

  def self.send_status
    {
      :not_send => 0,
      :sending => 1,
      :sent => 2
    }
  end

  def status
    self.class.status.each do |status_name, status_id|
      return status_name if self.status_id == status_id
    end
  end

  self.send_status.each do |status_name, status_id|
    define_method "#{status_name}?".to_sym do
      self.send_status_id == status_id
    end
  end


  def element_status
    self.class.element_status.each do |status_name, status_id|
      return status_name if self.element_status_id == status_id
    end
  end

  def send_status
    self.class.send_status.each do |status_name, status_id|
      return status_name if self.send_status_id == status_id
    end
  end

  def count_elements
    # 各零件总需求
    self.update_need_count_elements

    # 各零件已配货
    self.update_rationed_count_elements

    # 各零件未配货
    self.update_not_ration_count_elements

    # 各产品已发货
    self.update_shipped_count_products

    # 各产品未发货
    self.update_not_shipped_count_products

    # 更新各种状态
    self.update_is_ready_status
    self.update_element_status
    self.update_send_status

    # 更新相关产品状态
    self.update_products_status
  end

  def check_need_count_elements
    $count_redis.hgetall "order_#{self.id}_need_count"
  end

  def check_not_ration_count_elements
    $count_redis.hgetall "order_#{self.id}_not_ration_count"
  end

  def check_rationed_count_elements
    $count_redis.hgetall "order_#{self.id}_rationed_count"
  end

  def check_shipped_count_products
    $count_redis.hgetall "order_#{self.id}_shipped_count"
  end

  def check_not_shipped_count_products
    $count_redis.hgetall "order_#{self.id}_not_shipped_count"
  end

  def update_need_count_elements
    $count_redis.del "order_#{self.id}_need_count"
    self.line_items.each do |line_item|
      line_item.product.need_count_elements_for_order(self.id, line_item.product_count * line_item.unit.rate)
    end
  end

  def update_rationed_count_elements
    $count_redis.del "order_#{self.id}_rationed_count"
    self.rations.each do |ration|
      ration.ration_records.each do |record|
        record.product.rationed_count_elements_for_order(self.id, record.product_count * record.unit.rate)
      end
    end
  end

  def update_not_ration_count_elements
    $count_redis.del "order_#{self.id}_not_ration_count"
    self.check_need_count_elements.each do |product_id, need_count|
      rationed_count = $count_redis.hget("order_#{self.id}_rationed_count", product_id).to_f
      count = need_count.to_f - rationed_count.to_f
      $count_redis.hset("order_#{self.id}_not_ration_count", product_id, count) if count > 0
    end
  end

  def update_is_ready_status
    self.check_not_ration_count_elements.each do |product_id, need_count|
      product = Product.find(product_id)
      self.update_attribute(:is_ready, false) and return if product.store < need_count.to_f
    end
    self.update_attribute(:is_ready, true)
  end

  def update_element_status
    if self.check_not_ration_count_elements.blank?
      self.update_attribute(:element_status_id, Order.element_status[:rationed])
    elsif self.check_rationed_count_elements.present?
      self.update_attribute(:element_status_id, Order.element_status[:rationing])
    end
  end

  def not_ration_products
    Product.where(["id in (?)", self.check_not_ration_count_elements.keys])
  end

  def update_shipped_count_products
    $count_redis.del "order_#{self.id}_shipped_count"
    self.shipments.each do |shipment|
      shipment.shipment_records.each do |record|
        $count_redis.hincrbyfloat("order_#{self.id}_shipped_count", record.product.id, record.product_count * record.unit.rate)
      end
    end
  end

  def update_not_shipped_count_products
    $count_redis.del "order_#{self.id}_not_shipped_count"
    self.line_items.each do |line_item|
      $count_redis.hincrbyfloat("order_#{self.id}_not_shipped_count", line_item.product.id, line_item.product_count * line_item.unit.rate)
    end
    self.check_shipped_count_products.each do |product_id, sent_count|
      not_shipped_count = $count_redis.hget("order_#{self.id}_not_shipped_count", product_id).to_f
      count = not_shipped_count.to_f - sent_count.to_f
      $count_redis.hset("order_#{self.id}_not_shipped_count", product_id, count) if count > 0
    end
  end

  def update_send_status
    if self.check_not_shipped_count_products.blank?
      self.update_attribute(:send_status_id, Order.send_status[:sent])
    elsif self.check_shipped_count_products.present?
      self.update_attribute(:send_status_id, Order.send_status[:sending])
    end
  end

  def update_products_status
    self.check_need_count_elements.each do |product_id, need_count|
      Product.find(product_id).count_orders
    end
  end

end
