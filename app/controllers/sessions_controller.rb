class SessionsController < ApplicationController

  before_filter :login_required, :except => [:new, :create]

  def new
    params[:session] ||= {}
  end

  def create
    user = User.find_by_login(params[:session][:login])
    if user
      if user.authenticate(params[:session][:password])
        session[:current_user_id] = user.id
        flash.notice = "登陆成功！"
        redirect_to root_path and return
      else
        flash[:error] = "密码错误！"
      end
    else
      flash[:error] = "用户名错误！"
    end
    render :new
  end

  def destroy
    session[:current_user_id] = nil
    redirect_to root_path and return
  end

end
