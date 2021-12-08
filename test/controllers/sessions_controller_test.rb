require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  test "should get new" do
    get root_path
    assert_response :success

  end
  #
  # test "should post login" do
  #   post sessions_login_path
  #   assert_response :success
  #
  # end
  #
  # test "should delete logout" do
  #   delete sessions_logout_path
  #   assert_response :success
  #
  # end
  #
  # test "should get logout" do
  #   get sessions_logout_path
  #   assert_response :success
  #
  # end
end
