require 'test_helper'

class ChatsControllerTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user = users(:rg_test)
  end

  # test "should get chatroom" do
  #   get chatroom_path
  #   assert_response :success
  #
  # end

  test "should redirect to login when not logged in" do
    get chats_path
    assert_not flash.empty?
    assert_redirected_to root_path
  end

end
