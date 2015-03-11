class AddIsCoreToProducts < ActiveRecord::Migration
  def change
    add_column :products, :is_core, :boolean, :default => false
  end
end
