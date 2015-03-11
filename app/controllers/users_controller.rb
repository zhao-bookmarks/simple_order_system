class UsersController < ApplicationController

  before_filter :login_required

  def index
    @q = User.search(params[:q])
    @users = @q.result.page(params[:page]).per(10)
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash.notice = "保存成功！"
      redirect_to user_path(@user) and return
    else
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      redirect_to user_path(@user) and return
    else
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
  end

  protected

  def user_params
    params.require(:user).permit(:login, :password, :password_confirmation, :name)
  end
end
