class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :user_id
      t.integer :type_id
      t.integer :target_id
      t.text :content
      t.boolean :is_read, :default => false

      t.timestamps
    end
  end
end
