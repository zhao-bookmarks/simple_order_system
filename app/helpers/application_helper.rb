module ApplicationHelper

  def show_boolean_with_text(flag)
    flag ? "是" : "否"
  end

  def show_boolean_with_checkbox_for_yes(flag)
    raw "<input type='checkbox' checked='checked' disabled>"  if flag
  end

  def show_boolean_with_checkbox_for_all(flag)
    if flag
      raw "<input type='checkbox' checked='checked' disabled>"
    else
      raw "<input type='checkbox' disabled>"
    end
  end

  def short_date(d)
    d.strftime("%Y-%m-%d") if d.present?
  end

  def short_date_time(d)
    d.strftime("%Y-%m-%d %H:%M:%S") if d.present?
  end

  def line_item_product_count(line_item)
    "#{line_item.product_count} #{line_item.unit.name}"
  end

  def line_item_delivery_date(line_item)
    if line_item.delivery_start.present? && line_item.delivery_end.present?
      "#{short_date line_item.delivery_start} ~ #{short_date line_item.delivery_end}"
    else
      "#{short_date line_item.delivery_start}"
    end
  end

  def show_product_count(product, count)
    "#{count} #{product.base_unit.name}"
  end

  def product_rationed_count_for_order(order, product)
    $count_redis.hget("order_#{order.id}_rationed_count", product.id).to_f
  end

  def product_not_ration_count_for_order(order, product)
    $count_redis.hget("order_#{order.id}_not_ration_count", product.id).to_f
  end

  def show_product_status(product, count)
    if count > 0
      raw "<span class='label label-success'>库存盈余 #{show_product_count(product, count)}</span>"
    elsif count < 0
      raw "<span class='label label-danger'>库存缺货 #{show_product_count(product, count.abs)}</span>"
    else
      raw "<span class='label label-default'>库存归零 #{show_product_count(product, count)}</span>"
    end
  end

  def show_is_ready_for_order(order)
    if order.is_ready
      raw "<span class='label label-success'>零件齐备</span>"
    else
      raw "<span class='label label-danger'>零件缺货</span>"
    end
  end

  def translate_role_name(role_name)
    t("user.roles.#{role_name}")
  end

  def roles_array
    User.roles.map do |key, value|
      [translate_role_name(key), value]
    end
  end

  def translate_order_status_name(status_name)
    t("order.status.#{status_name}")
  end

  def order_status_array
    Order.status.map do |key, value|
      [translate_order_status_name(key), value]
    end
  end

  def translate_order_element_status_name(status_name)
    t("order.element_status.#{status_name}")
  end

  def order_element_status_array
    Order.element_status.map do |key, value|
      [translate_order_element_status_name(key), value]
    end
  end

  def translate_order_send_status_name(status_name)
    t("order.send_status.#{status_name}")
  end

  def order_send_status_array
    Order.send_status.map do |key, value|
      [translate_order_send_status_name(key), value]
    end
  end

  def show_product_send_status_for_order(order_id, product_id)
    not_shipped_count = $count_redis.hget("order_#{order_id}_not_shipped_count", product_id).to_f
    shipped_count = $count_redis.hget("order_#{order_id}_shipped_count", product_id).to_f

    if shipped_count == 0
      "未开始发货"
    elsif not_shipped_count == 0
      "已完成发货"
    else
      "已经发货 #{shipped_count}, 尚未发货 #{not_shipped_count}"
    end
  end

  def show_low_status(product)
    raw "<span class='label label-warning'>预警</span>" if product.is_low
  end

  def show_out_of_stock_status(product)
    raw "<span class='label label-danger'>缺货</span>" if product.is_out_of_stock
  end

  def show_total(product)
    html = ""
    total_count = 0
    product.check_count_orders.each do |order_id, need_count|
      html += link_to "订单##{order_id}", order_path(order_id)
      html += " 需求 #{need_count} <br>"
      total_count += need_count.to_f
    end
    html += "总需求: #{total_count}"
    html += "<br>总缺货: <code>#{total_count - product.store.to_f}</code>" if total_count > product.store.to_f
    raw html if total_count > 0
  end

end
