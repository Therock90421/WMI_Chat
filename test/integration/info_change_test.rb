require 'test_helper'

class InfoChangeTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user = users(:rg_test)
    @name = "changed_test"
    @sex = "女"
    @phonenumber = "123123"
    @status = "changed"
    @essay = "just a change test"
  end

  test "unsuccessful change user info" do
    get root_path
    post sessions_login_path, params: { session: { email: @user.email,
                                                   password: 'password' } }
    assert is_logged_in?
    assert_redirected_to chats_path
    follow_redirect!
    # assert_template ''
    patch user_path(@user), params: { user: { name: "",
                                              sex: @sex,
                                              phonenumber: @phonenumber,
                                              status: @status,
                                              essay: @essay } }
    assert_not flash.empty?
    assert_not_equal @user.reload.name, ""
    assert_not_equal @user.reload.sex, @sex
    assert_not_equal @user.reload.phonenumber, @phonenumber
    assert_not_equal @user.reload.status, @status
    assert_not_equal @user.reload.essay, @essay
    # assert_template 'users/edit'
  end

  test "successful change user info" do
    get root_path
    post sessions_login_path, params: { session: { email: @user.email,
                                                   password: 'password' } }
    assert is_logged_in?
    assert_redirected_to chats_path
    follow_redirect!
    # assert_template ''
    patch user_path(@user), params: { user: { name: @name,
                                              sex: @sex,
                                              phonenumber: @phonenumber,
                                              status: @status,
                                              essay: @essay } }
    assert_not flash.empty?
    assert_equal @user.reload.name, @name
    assert_equal @user.reload.sex, @sex
    assert_equal @user.reload.phonenumber, @phonenumber
    assert_equal @user.reload.status, @status
    assert_equal @user.reload.essay, @essay
    # assert_template 'users/edit'
  end

end


