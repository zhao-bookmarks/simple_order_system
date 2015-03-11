class OrdersController < ApplicationController

  before_filter :login_required

  def index
    @q = Order.search(params[:q])
    @orders = @q.result.page(params[:page]).per(10)
  end

  def new
    @order = Order.new
    @order.line_items.build
    @products = Product.last_products
  end

  def create
    @order = Order.new(order_params)
    @order.user = current_user
    if @order.save
      redirect_to order_path(@order) and return
    else
      @products = Product.last_products
      render :new
    end
  end

  def show
    @order = Order.find(params[:id])
  end

  def new_ration
    @order = Order.find(params[:id])
    @ration = @order.rations.build
    @ration.ration_records.build({:product_count => 0})
  end

  def create_ration
    @order = Order.find(params[:id])
    @ration = @order.rations.new(ration_params)
    @ration.user = current_user
    if @ration.save
      redirect_to order_path(@order) and return
    else
      render :new_ration
    end
  end

  def rations
    @order = Order.find(params[:id])
    @rations = @order.rations
  end

  def new_shipment
    @order = Order.find(params[:id])
    @shipment = @order.shipments.build
    @shipment.shipment_records.build({:product_count => 0})
  end

  def create_shipment
    @order = Order.find(params[:id])
    @shipment = @order.shipments.new(shipment_params)
    @shipment.user = current_user
    if @shipment.save
      redirect_to order_path(@order) and return
    else
      render :new_shipment
    end
  end

  def shipments
    @order = Order.find(params[:id])
    @shipments = @order.shipments
  end

  protected

  def order_params
    params.require(:order).permit(
      :number, :remark,
      :line_items_attributes => [:id, :product_id, :unit_id, :product_count, :delivery_start, :delivery_end, :remark, :_destroy]
    )
  end

  def ration_params
    params.require(:ration).permit(
      :ration_records_attributes => [:id, :product_id, :unit_id, :product_count, :_destroy]
    )
  end

  def shipment_params
    params.require(:shipment).permit(
      :shipment_records_attributes => [:id, :product_id, :unit_id, :product_count, :_destroy]
    )
  end

end
