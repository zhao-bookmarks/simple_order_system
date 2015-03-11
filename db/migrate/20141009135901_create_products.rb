class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :number
      t.string :name
      t.boolean :is_minimum, :default => false
      t.boolean :is_last, :default => false

      t.timestamps
    end
  end
end
