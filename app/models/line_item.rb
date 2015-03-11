class LineItem < ActiveRecord::Base

  belongs_to :order
  belongs_to :product
  belongs_to :unit

  validates :product_id, :presence => true
  validates :unit_id, :presence => true
  validates :product_count, :presence => true

  def core_product
    self.product.core_product
  end

end
