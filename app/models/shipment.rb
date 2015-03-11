class Shipment < ActiveRecord::Base

  belongs_to :user
  belongs_to :order
  has_many :shipment_records
  accepts_nested_attributes_for :shipment_records, :allow_destroy => true

  after_create :update_order

  protected

  def update_order
    self.order.count_elements
  end
  
end
