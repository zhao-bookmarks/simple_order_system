class Product < ActiveRecord::Base

  mount_uploader :photo, ProductPhotoUploader

  has_many :units, :dependent => :destroy
  accepts_nested_attributes_for :units, :allow_destroy => true

  has_many :sub_products, :class_name => "SubProduct", :foreign_key => :parent_id, :dependent => :destroy
  accepts_nested_attributes_for :sub_products, :allow_destroy => true

  has_many :warehouse_records

  validates :name, :presence => true, :uniqueness => true
  validates :store, :presence => true

  attr_accessor :warehouse_log_remark

  scope :minimum_products, -> {where(["is_minimum is true"])}
  scope :last_products, -> {where(["is_last is true"])}

  def base_unit
    self.units.where(["is_base is true"]).first rescue nil
  end

  def core_product
    find_core_product(self)
  end

  def need_count_elements_for_order(order_id, need_count)
    if self.is_minimum
      $count_redis.hincrbyfloat("order_#{order_id}_need_count", self.id, need_count)
    else
      self.sub_products.each do |sp|
        sp.product.need_count_elements_for_order(order_id, need_count * sp.product_count * sp.unit.rate)
      end
    end
  end

  def rationed_count_elements_for_order(order_id, rationed_count)
    if self.is_minimum
      $count_redis.hincrbyfloat("order_#{order_id}_rationed_count", self.id, rationed_count)
    else
      self.sub_products.each do |sp|
        sp.product.rationed_count_elements_for_order(order_id, rationed_count * sp.product_count * sp.unit.rate)
      end
    end
  end

  def count_orders
    $count_redis.del "product_#{self.id}_need_count"
    Order.not_rationed.each do |order|
      need_count = $count_redis.hget("order_#{order.id}_not_ration_count", self.id).to_f
      $count_redis.hincrbyfloat("product_#{self.id}_need_count", order.id, need_count) if need_count > 0
    end
    self.update_out_of_stock_status
    self.update_low_status
  end

  def check_count_orders
    $count_redis.hgetall "product_#{self.id}_need_count"
  end

  def update_out_of_stock_status
    total_count = 0
    self.check_count_orders.each do |order_id, need_count|
      total_count += need_count.to_f
    end
    self.update_attribute(:is_out_of_stock, total_count.to_f > self.store.to_f)
  end

  def update_low_status
    self.update_attribute(:is_low, self.alert_count.to_f > self.store.to_f)
  end

  protected

  def find_core_product(p)
    return p if p.is_core
    p.sub_products.each do |sp|
      cp = find_core_product(sp.product)
      return cp if cp.present?
    end
    nil
  end

end
