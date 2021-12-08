require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
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
    @user1 = users(:rg_test1)
    @chat = chats(:chat1)
  end

  test "should redirect to root when not logged in & trying to update" do
    patch user_path(@user), params: { user: { name: @name,
                                              sex: @sex,
                                              phonenumber: @phonenumber,
                                              status: @status,
                                              essay: @essay } }
    assert_not flash.empty?
    assert_not_equal @user.reload.name, @name
    assert_not_equal @user.reload.sex, @sex
    assert_not_equal @user.reload.phonenumber, @phonenumber
    assert_not_equal @user.reload.status, @status
    assert_not_equal @user.reload.essay, @essay
    assert_redirected_to root_path
  end

  test "should redirect to root when logged in as wrong user & trying to update" do
    log_in_as(@user1)
    patch user_path(@user), params: { user: { name: @name,
                                              sex: @sex,
                                              phonenumber: @phonenumber,
                                              status: @status,
                                              essay: @essay } }
    assert_not flash.empty?
    assert_not_equal @user.reload.name, @name
    assert_not_equal @user.reload.sex, @sex
    assert_not_equal @user.reload.phonenumber, @phonenumber
    assert_not_equal @user.reload.status, @status
    assert_not_equal @user.reload.essay, @essay
    assert_redirected_to @user1
  end

  test "successful change info with friendly forwarding" do
    get chats_path(@chat)
    log_in_as(@user)
    assert_redirected_to chats_path(@chat)
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
    assert_redirected_to chats_path
  end
end
