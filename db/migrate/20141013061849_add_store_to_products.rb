class AddStoreToProducts < ActiveRecord::Migration
  def change
    add_column :products, :store, :decimal, :default => 0
  end
end
