# frozen_string_literal: true

require 'test_helper'

class NotificationsControllerTest < ActionDispatch::IntegrationTest
  # Devise & Warden will help in signing in user while testing where we need authentication
  include Devise::Test::IntegrationHelpers
  include Warden::Test::Helpers

  test 'should retrieve notifications for current user' do
    user = FactoryBot.create(:user)
    login_as(user, scope: :user)
    get '/notifications'
    logout(:user)
    assert_response :success
  end
end
