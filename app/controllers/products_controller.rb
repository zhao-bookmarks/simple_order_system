class ProductsController < ApplicationController

  before_filter :login_required

  def index
    @q = Product.search(params[:q])
    @products = @q.result.page(params[:page]).per(10)
  end

  def show
    @product = Product.find(params[:id])
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to product_path(@product) and return
    else
      render :new
    end
  end

  def edit
    @product = Product.find(params[:id])
  end

  def edit_units
    @product = Product.find(params[:id])
    @product.units.build({:is_default => true, :is_base => true, :rate => 1.0}) if @product.units.blank?
  end

  def edit_sub_products
    @product = Product.find(params[:id])
    redirect_to product_path(@product) and return if @product.is_minimum
    @products = Product.all
    @product.sub_products.build({:product_count => 0}) if @product.sub_products.blank?
  end

  def update
    @product = Product.find(params[:id])
    if @product.update_attributes(product_params)
      redirect_to product_path(@product) and return 
    else
      if params[:product][:units_attributes].present?
        render :edit_units
      elsif params[:product][:sub_products_attributes].present?
        @products = Product.all
        render :edit_sub_products
      else
        render :edit
      end
    end
  end

  def destroy
    @product = Product.find(params[:id])
    @product.destroy
    redirect_to products_path and return
  end

  def get_units
    @product = Product.find(params[:id])
    @units = @product.units
    render :json => @units.to_json and return
  end

  protected

  def product_params
    params.require(:product).permit(
      :number, :name, :photo, :is_minimum, :is_last, :is_core, 
      :units_attributes => [:id, :name, :is_default, :is_base, :rate, :_destroy],
      :sub_products_attributes => [:id, :product_id, :unit_id, :product_count, :_destroy]
    )
  end

end
