class CreatePurchaseRecords < ActiveRecord::Migration
  def change
    create_table :purchase_records do |t|
      t.integer :purchase_id
      t.integer :product_id
      t.integer :unit_id
      t.decimal :product_count, :default => 0

      t.timestamps
    end
  end
end
