class ChatsController < ApplicationController
  include SessionsHelper
  include ChatsHelper
#   respond_to :js, :html
  before_action :logged_in
  before_action :set_chat, except: [:index, :new, :create, :chatroom]
  before_action :correct_user, only: :show

  def index
    @friends=current_user.friends+current_user.inverse_friends
    @user_form = current_user
    @onlineusers = User.all.where(online: 1)
    offlineusers = User.all.where(online: 0)
    @onlinefriends = @friends-offlineusers
    @onlineusers = @onlineusers-[current_user]-@friends
    @newarticle = Article.new
    @selfarticle = current_user.articles
    fa1 = Article.find_by_sql("select articles.*, users.name, users.email from users, friendships, articles where users.id = friendships.user_id and friendships.friend_id = articles.user_id and users.id = " + current_user.id.to_s);
    fa2 = Article.find_by_sql("select articles.*, users.name, users.email from users, friendships, articles where users.id = friendships.friend_id and friendships.user_id = articles.user_id and users.id = " + current_user.id.to_s);
    @friendsarticle = fa1+fa2
    @userinfo = current_user
    @currentallchat = current_user.chats
    @footstepall = @userinfo.footsteps
    robot = User.find_by(email: "robot@test.com")
    if robot.nil?
      robot = User.new(:name=> "robot", :email=> "robot@test.com", :online =>"1", :password=> "123456")
      #robot = User.new(:name=> "robot", :email=> "robot@test.com", :online =>"1", :password=> "123456", :picture => "/asserts/robot.jpg")
      if robot.save!
        flash= {success: "创建机器人成功"}
        redirect_to chats_path, flash: flash
      else
        flash= {danger: "创建机器人失败，请联系管理人员"}
        redirect_to root_path, flash: flash
      end
    end
  end

  def add_user
    if params[:users].nil?
      redirect_to chat_path(@chat), flash: {:info => "选择的用户组为空"}
    else
      params[:users].each do |id|
        @chat.users<<User.find_by_id(id)
      end
      redirect_to chat_path(@chat), flash: {:info => "用户已成功拉入群聊"}
    end
  end

  def delete_user
    user=User.find_by_id(params[:user_id])
    @chat.users.delete(user)
    if @chat.users.count == 1
      @chat.users.delete(@chat.users[0][:id])
    end
    redirect_to chat_path(@chat), flash: {:warning => "#{user.name}已成功退出群聊"}
  end

  def create
    user=User.find_by_id(params[:users])

    current_user.chats.each do |chat|
      if (chat.users-[user, current_user]).blank?
        redirect_to chat_path(chat) and return
      end
    end

    @chat = Chat.new
    @chat.users<<user
    @chat.users<<current_user
    @chat.admin_id=current_user.id
    @chat.name="#{user.name}-#{current_user.name}"
    Rails.logger.info(user)
    Rails.logger.info(current_user)
    Rails.logger.info("==============================")

    if @chat.save!
      redirect_to chat_path(@chat)
    else
      flash[:warning] = "错误,请重试"
      # redirect_to chats_path
      render 'chats/show'
    end
  end

  def update
    if @chat.update_attributes(chat_params)
      flash= {success: "修改成功"}
    else
      flash= {danger: "修改失败，请重试"}
    end
    redirect_to chat_path(@chat), flash: flash
  end

  def trans_auth
    @chat.update_attribute(:admin_id, params[:admin_id])
    redirect_to chat_path(@chat), flash: {success: '移交成功！'}
  end

  def destroy
    @chat.destroy
    redirect_to chatroom_path, flash: {:danger => '聊天已删除'}
  end

  def show
    @new_message = Message.new
    @users_in_chat= @chat.users-[current_user]
    @friends=current_user.friends+current_user.inverse_friends
    robot = User.find_by(email: "robot@test.com")
    @friends_out_chat=@friends-@chat.users-[robot]
    offlineusers = User.all.where(online: 0)
    @onchatuser = @chat.users-offlineusers
    @currentallchat = current_user.chats-[@chat]
  end

  def chatroom
    friends=current_user.friends+current_user.inverse_friends
    if friends.count == 0
      redirect_to chats_path, flash: {:danger => 'no friends'}
    else
      if current_user.chats.count == 0
        user=friends[0]
        @chat = Chat.new
        @chat.users<<user
        @chat.users<<current_user
        @chat.admin_id=current_user.id
        @chat.name="#{user.name}-#{current_user.name}"
        if @chat.save
          redirect_to chat_path(@chat)
        else
          flash[:warning] = "错误,请重试"
          redirect_to chats_path
        end
      else
        redirect_to chat_path(current_user.chats[0])
      end
    end
  end

  # private

  def chat_params
    params.require(:chat).permit(:name, :description)
  end

  def logged_in
    #logged_in = false
    unless logged_in?
      store_location
      redirect_to root_url, flash: {danger: '请登陆'}
    end
  end

  def set_chat
    @chat=Chat.find_by_id(params[:id])
    if @chat.nil?
      redirect_to chats_path, flash: {:warning => "没有找到此次聊天的信息"}
    end
  end

  def correct_user
    if @chat.users.include?(current_user)
    else
      redirect_to chatroom_path, flash: {warning: '聊天已删除'}
    end
  end

end
