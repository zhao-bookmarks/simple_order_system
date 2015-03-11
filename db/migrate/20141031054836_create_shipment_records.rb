class CreateShipmentRecords < ActiveRecord::Migration
  def change
    create_table :shipment_records do |t|
      t.integer :shipment_id
      t.integer :product_id
      t.integer :unit_id
      t.decimal :product_count

      t.timestamps
    end
  end
end
