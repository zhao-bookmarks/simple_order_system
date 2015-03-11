class AddIsReadyToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :is_ready, :boolean, :default => false
  end
end
