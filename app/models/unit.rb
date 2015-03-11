class Unit < ActiveRecord::Base

  belongs_to :product

  validates :name, :presence => true
end
