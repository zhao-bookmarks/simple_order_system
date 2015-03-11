class CreateLineItems < ActiveRecord::Migration
  def change
    create_table :line_items do |t|
      t.integer :order_id
      t.integer :product_id
      t.integer :unit_id
      t.decimal :product_count, :default => 0
      t.date :delivery_start
      t.date :delivery_end
      t.text :remark

      t.timestamps
    end
  end
end
