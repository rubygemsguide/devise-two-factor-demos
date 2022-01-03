require 'application_system_test_case'

class Disable2FATest < ApplicationSystemTestCase

  setup do
    @hopper = users(:hopper)
    setup_2fa(@hopper)
    sign_in(@hopper)
  end

  test "can success disable 2FA and login without 2FA" do
    visit two_factor_authentication_path
    assert_selector "h1", text: "Two-factor authentication"
    assert_selector "h2", text: "Authenticator app"
    assert_selector "h2", text: "Recovery codes"

    click_on "Disable"
    assert_button "Enable"

    click_on "Logout"
    assert_content "Signed out successfully."

    click_on "Login"
    assert_selector "h2", text: "Log in"

    fill_in "Email", with: "hopper@example.com"
    fill_in "Password", with: "12345678"
    click_button "Log in"
    assert_selector "h1", text: "Dashboard"

    click_link "Two-factor authentication"
    assert_selector "h1", text: "Two-factor authentication"
    assert_button "Enable"
  end

end
