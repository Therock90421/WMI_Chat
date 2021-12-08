require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
    @invalid_su_users = []
    @invalid_su_users.append({ name: "",
                           email: "user@test.com",
                           password: "123456",
                           password_confirmation: "123456" })
    @invalid_su_users.append({ name: "test",
                               email: "",
                               password: "123456",
                               password_confirmation: "123456" })
    @invalid_su_users.append({ name: "test",
                               email: "user@test.com",
                               password: "",
                               password_confirmation: "123456" })
    @invalid_su_users.append({ name: "",
                               email: "user@invalid",
                               password: "123456",
                               password_confirmation: "" })
  end

  test "invalid signup information should be rejected" do
    get new_user_path
    @invalid_su_users.each do |user|
      assert_no_difference 'User.count', "signup user #{user} should be invalid" do
        post users_path, params: { user: user }
      end
      # assert_select 'div#<CSS id for error explanation>'
      # assert_select 'div.<CSS class for field with error>'
      # assert_template 'users/new'
      # assert_redirected_to new_user_path, "should return to signup"
      assert_template 'users/_register'
      assert_not flash.empty?
      get root_path
      assert flash.empty?
    end
  end

  test "valid signup information" do
    get new_user_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name: "Example User",
                                         email: "user@example.com",
                                         password: "password",
                                         password_confirmation: "password" } }
    end
    assert_redirected_to chats_path
    follow_redirect!
    # assert_template ''
    assert is_logged_in?
    assert_not flash.empty?
  end
end
