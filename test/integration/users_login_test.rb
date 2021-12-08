require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:rg_test)
  end

  # test "the truth" do
  #   assert true
  # end
  test "login with invalid information" do
    get root_path
    assert_template 'homes/_login'
    post sessions_login_path, params: { session: { email: "", password: "" } }
    assert_not is_logged_in?
    assert_template 'homes/_login'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test "login with valid information" do
    get root_path
    post sessions_login_path, params: { session: { email: @user.email,
                                          password: 'password' } }
    # assert_redirected_to user_path(@user)
    assert is_logged_in?
    assert_redirected_to chats_path
    follow_redirect!
    # assert_template ''
    assert_select "a[href=?]", sessions_login_path, count: 0
    # assert_select "a[href=?]", sessions_logout_path
    # assert_select "a[href=?]", user_path(@user)
    # assert_select "row"
  end

  test "login with valid email/invalid password" do
    get root_path
    assert_template 'homes/_login'
    post sessions_login_path, params: { session: { email: @user.email,
                                          password: "invalid" } }
    assert_template 'homes/_login'
    assert_not is_logged_in?
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test "successfully login and then logout" do
    get root_path
    post sessions_login_path, params: { session: { email: @user.email,
                                          password: 'password' } }
    assert is_logged_in?
    assert_redirected_to chats_path
    follow_redirect!
    # assert_template 'users/show'
    assert_select "a[href=?]", sessions_login_path, count: 0
    # assert_select "a[href=?]", sessions_login_path
    # assert_select "a[href=?]", user_path(@user)
    delete sessions_logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    follow_redirect!
    # 模拟用户在另一个窗口中点击退出链接
    delete sessions_logout_path
    # assert_select "a[href=?]", sessions_login_path
    assert_select "a[href=?]", sessions_login_path, count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end

  test "login with remembering" do
    log_in_as(@user, remember_me: '1')
    assert_not cookies[:remember_token].blank?
    assert_equal cookies[:remember_token], assigns(:user).remember_token
  end

  test "login without remembering" do
    # 登录，设定 cookie
    log_in_as(@user, remember_me: '1')
    # 再次登录，确认 cookie 被删除了
    log_in_as(@user, remember_me: '0')
    assert cookies[:remember_token].blank?
  end


end
