crumb :root do
  link "首页", root_path
end

crumb :users do
  link "用户列表", users_path
end

crumb :user do |user|
  if user.id.blank?
    link "新建用户", "javascript:;"
  else
    link user.login, user_path(user)
  end
  parent :users
end

crumb :products do
  link "产品列表", products_path
end

crumb :product do |product|
  if product.id.blank?
    link "新建产品", "javascript:;"
  else
    link product.name, product_path(product)
  end
  parent :products
end

crumb :edit_product do |product|
  link "编辑", "javascript:;"
  parent :product, product
end

crumb :orders do
  link "订单列表", orders_path
end

crumb :order do |order|
  if order.id.blank?
    link "新建订单", "javascript:;"
  else
    link order.number, order_path(order)
  end
  parent :orders
end

crumb :ration do |ration|
  if ration.id.blank?
    link "新建配货", "javascript:;"
    parent :order, Order.find(params[:id])
  end
end

crumb :rations do
  link "配货记录", rations_order_path(params[:id])
  parent :order, Order.find(params[:id])
end

crumb :warehouses do
  link "库存列表", warehouses_path
end

crumb :warehouse do |warehouse|
  link warehouse.name, warehouse_path(warehouse)
  parent :warehouses
end

crumb :purchases do
  link "进货记录", purchases_path
  parent :warehouses
end

crumb :purchase do |purchase|
  link "##{purchase.id}", purchase_path(purchase)
  parent :purchases
end

# crumb :projects do
#   link "Projects", projects_path
# end

# crumb :project do |project|
#   link project.name, project_path(project)
#   parent :projects
# end

# crumb :project_issues do |project|
#   link "Issues", project_issues_path(project)
#   parent :project, project
# end

# crumb :issue do |issue|
#   link issue.title, issue_path(issue)
#   parent :project_issues, issue.project
# end

# If you want to split your breadcrumbs configuration over multiple files, you
# can create a folder named `config/breadcrumbs` and put your configuration
# files there. All *.rb files (e.g. `frontend.rb` or `products.rb`) in that
# folder are loaded and reloaded automatically when you change them, just like
# this file (`config/breadcrumbs.rb`).