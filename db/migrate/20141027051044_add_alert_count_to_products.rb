class AddAlertCountToProducts < ActiveRecord::Migration
  def change
    add_column :products, :alert_count, :decimal, :default => 0
  end
end
