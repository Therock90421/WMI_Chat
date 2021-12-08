require 'test_helper'

class HomesControllerTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  test "should get home" do
    get root_path
    assert_response :success

  end
end
