class SessionsController < ApplicationController
  include SessionsHelper

  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user && @user.authenticate(params[:session][:password])
      forwarding_url = session[:forwarding_url]
      log_in @user
      @user.update_attributes(online: 1)
      params[:session][:remember_me] == '1' ? remember_user(@user) : forget_user(@user)
      # flash= {:info => "欢迎回来: #{user.name} :)"}
      flash[:info] = "欢迎回来: #{@user.name} :)"
      redirect_to forwarding_url || chats_path
    else
      # flash= {:danger => '账号或密码错误'}
      # flash.now[:danger] = '账号或密码错误'
      flash.now[:danger] = '账号或密码错误'
      render 'homes/home'
    end
    # redirect_to root_url, :flash => flash
  end

  def new
  end

  def destroy
    if logged_in?
      current_user.update_attributes(online: 0)
      log_out
    end
    redirect_to root_url
  end

end
