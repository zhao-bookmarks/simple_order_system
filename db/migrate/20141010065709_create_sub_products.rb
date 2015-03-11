class CreateSubProducts < ActiveRecord::Migration
  def change
    create_table :sub_products do |t|
      t.integer :parent_id
      t.integer :product_id
      t.integer :unit_id
      t.decimal :product_count, :default => 0

      t.timestamps
    end
  end
end
