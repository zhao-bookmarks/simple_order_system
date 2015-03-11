class AddRemarkToWarehouseLogs < ActiveRecord::Migration
  def change
    add_column :warehouse_records, :remark, :text
  end
end
