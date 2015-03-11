class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :user_id
      t.string :number
      t.text :remark

      t.timestamps
    end
  end
end
