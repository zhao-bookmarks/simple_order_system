class PurchasesController < ApplicationController

  before_filter :login_required

  def index
    @q = Purchase.search(params[:q])
    @purchases = @q.result.page(params[:page]).per(10)
  end

  def show
    @purchase = Purchase.find(params[:id])
  end

  def new
    @purchase = Purchase.new
    @purchase.purchase_records.build({:product_count => 0})
    @products = Product.minimum_products
  end

  def create
    @purchase = Purchase.new(purchase_params)
    @purchase.user = current_user
    if @purchase.save
      redirect_to warehouses_path and return
    else
      @products = Product.minimum_products
      render :new
    end
  end

  protected

  def purchase_params
    params.require(:purchase).permit(:purchase_records_attributes => [:id, :product_id, :unit_id, :product_count, :_destroy])
  end

end
