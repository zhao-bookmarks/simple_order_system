class Ration < ActiveRecord::Base

  belongs_to :user
  belongs_to :order
  has_many :ration_records
  accepts_nested_attributes_for :ration_records, :allow_destroy => true
  has_many :products, :through => :ration_records

  after_create :update_order_and_products
  
  protected

  def update_order_and_products
    # 更新存货量
    self.update_product_store

    # 更新 order 状态
    self.order.count_elements

    # 更新 product 需求列表和状态
    self.products.each do |product|
      product.count_orders
    end
  end

  def update_product_store
    self.ration_records.each do |record|
      store = record.product.store
      count = record.product_count * record.unit.rate
      record.product.update_attribute(:store, store - count)
    end
  end

end
