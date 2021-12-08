ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  # parallelize(workers: :number_of_processors, with: :threads)
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  # 如果用户已登录，返回 true
  def is_logged_in?
    !session[:user_id].nil?
  end

  # 登入指定的用户
  def log_in_as(user)
    session[:user_id] = user.id
  end

end

class ActionDispatch::IntegrationTest
  # 登入指定的用户
  def log_in_as(user, password: 'password', remember_me: '1')
    post sessions_login_path, params: { session: { email: user.email,
                                          password: password,
                                          remember_me: remember_me } }
  end
end
