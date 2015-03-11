class CreateShipments < ActiveRecord::Migration
  def change
    create_table :shipments do |t|
      t.integer :user_id
      t.integer :order_id

      t.timestamps
    end
  end
end
