class SubProduct < ActiveRecord::Base

  belongs_to :parent, :class_name => "Product", :foreign_key => :parent_id
  belongs_to :product, :foreign_key => :product_id
  belongs_to :unit

  validates :product_id, :presence => true
  validates :unit_id, :presence => true
  validates :product_count, :presence => true
end
