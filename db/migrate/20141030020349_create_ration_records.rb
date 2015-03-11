class CreateRationRecords < ActiveRecord::Migration
  def change
    create_table :ration_records do |t|
      t.integer :ration_id
      t.integer :product_id
      t.integer :unit_id
      t.decimal :product_count

      t.timestamps
    end
  end
end
