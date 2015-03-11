class CreateUnits < ActiveRecord::Migration
  def change
    create_table :units do |t|
      t.integer :product_id
      t.string :name
      t.boolean :is_default, :default => false
      t.boolean :is_base, :default => false
      t.decimal :rate, :default => 0

      t.timestamps
    end
  end
end
