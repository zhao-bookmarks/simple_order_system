class CreateWarehouseRecords < ActiveRecord::Migration
  def change
    create_table :warehouse_records do |t|
      t.integer :user_id
      t.integer :product_id
      t.decimal :old_store
      t.decimal :new_store

      t.timestamps
    end
  end
end
