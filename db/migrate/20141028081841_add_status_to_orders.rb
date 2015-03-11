class AddStatusToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :status_id, :integer, :default => 0
    add_column :orders, :element_status_id, :integer, :default => 0
    add_column :orders, :send_status_id, :integer, :default => 0
  end
end
