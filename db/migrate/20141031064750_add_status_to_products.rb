class AddStatusToProducts < ActiveRecord::Migration
  def change
    add_column :products, :is_low, :boolean, :default => false
    add_column :products, :is_out_of_stock, :boolean, :default => false
  end
end
