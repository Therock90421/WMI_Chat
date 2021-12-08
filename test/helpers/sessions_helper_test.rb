require 'test_helper'

class SessionsHelperTest < ActionView::TestCase
  # test "full title helper" do
  #   assert_equal log_in(user)
  # end
  def setup
    @user = users(:rg_test)
    remember_user(@user)
  end

  test "current_user returns right user when session is nil" do
    assert_equal @user, current_user
    assert is_logged_in?
  end

  test "current_user returns nil when remember digest is wrong" do
    @user.update_attribute(:remember_digest, User.digest(User.new_token))
    assert_nil current_user
  end
end
