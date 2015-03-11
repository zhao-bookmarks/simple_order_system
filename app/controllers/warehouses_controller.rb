class WarehousesController < ApplicationController

  before_filter :login_required

  def index
    @q = Product.minimum_products.search(params[:q])
    @products = @q.result.page(params[:page]).per(10)
  end

  def show
    @product = Product.find(params[:id])
  end

  def edit
    @product = Product.find(params[:id])
  end

  def update
    @product = Product.find(params[:id])
    old_store = @product.store
    if @product.update_attributes(warehouse_params)
      new_store = @product.store
      if old_store != new_store      
        WarehouseRecord.create({
          :user_id => current_user.id,
          :product_id => @product.id,
          :old_store => old_store,
          :new_store => new_store,
          :remark => @product.warehouse_log_remark
        })
      end
      redirect_to warehouses_path and return
    else
      render :edit
    end
  end

  def edit_alert_count
    @product = Product.find(params[:id])
  end

  def update_alert_count
    @product = Product.find(params[:id])
    if @product.update_attributes(warehouse_alert_params)
      @product.update_low_status # 更新预警状态
      redirect_to warehouses_path and return
    else
      render :edit_alert_count
    end
  end

  protected

  def warehouse_params
    params.require(:product).permit(:store, :warehouse_log_remark)
  end

  def warehouse_alert_params
    params.require(:product).permit(:alert_count)
  end
end
