require "test_helper"
require "support/helpers/system/authentication_system_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  include Devise::Test::IntegrationHelpers
  include AuthenticationSystemHelper

  driven_by :selenium, using: :chrome, screen_size: [1400, 1400]
end
