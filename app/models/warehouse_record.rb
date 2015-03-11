class WarehouseRecord < ActiveRecord::Base

  belongs_to :user
  belongs_to :product

  before_create :update_orders_and_product

  protected

  def update_orders_and_product
    # 更新 orders 状态
    Order.not_rationed.each do |order|
      order.count_elements
    end

    # 更新 product 状态
    self.product.count_orders
  end

end
