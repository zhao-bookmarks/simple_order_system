class RationRecord < ActiveRecord::Base

  belongs_to :ration
  belongs_to :product
  belongs_to :unit

  validates :product_id, :presence => true
  validates :unit_id, :presence => true
  validates :product_count, :presence => true
  
end
