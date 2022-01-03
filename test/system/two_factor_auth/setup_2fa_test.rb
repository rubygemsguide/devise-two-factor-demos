require 'application_system_test_case'

class Setup2FATest < ApplicationSystemTestCase

  setup do
    @hopper = users(:hopper)
    sign_in @hopper
  end

  test "can success setup 2FA and login with it" do
    visit root_path
    assert_selector "h1", text: "Dashboard"

    click_link "Two-factor authentication"
    assert_selector "h1", text: "Two-factor authentication"
    assert_selector "h2", text: "Authenticator app"

    click_on "Enable"
    assert_selector "h1", text: "Setup Two-Factor Authentication"
    assert_selector "p", text: "Use your two-factor authentication app to scan the QR code"

    click_on "Cancel"
    assert_selector "h1", text: "Two-factor authentication"
    assert_equal two_factor_authentication_path, page.current_path

    click_on "Enable"
    assert_selector "h1", text: "Setup Two-Factor Authentication"

    token = scan_the_qr_code_and_get_an_onetime_token(@hopper)
    fill_in_digit_fields_with token
    click_button "Confirm and activate"
    assert_selector "h1", text: "2FA Setup Success"
    assert_selector "p", text: "Save this emergency backup code and store it somewhere safe."
    assert_selector "li", count: 12
    all("li").each do |li|
      assert_match /\w{8}/, li.text
    end

    click_on "Done"
    assert_selector "h1", text: "Two-factor authentication"
    assert_selector "h2", text: "Authenticator app"
    assert_button "Disable"
    assert_selector "h2", text: "Recovery codes"
    assert_button "Regenerate"

    click_on "Regenerate" # Regenerate recovery codes
    assert_selector "h1", text: "Regenerate Recovery Codes Success"
    assert_selector "p", text: "Save this emergency backup code and store it somewhere safe. (All previous codes are expired.)"
    assert_selector "li", count: 12
    save_recovery_codes

    click_on "Done"
    assert_selector "h1", text: "Two-factor authentication"

    ####################
    ## Login with 2FA ##
    ####################

    click_on "Logout"
    assert_content "Signed out successfully."

    click_on "Login"
    assert_selector "h2", text: "Log in"

    travel_to 30.seconds.after do
      fill_in 'Email', with: 'hopper@example.com'
      fill_in 'Password', with: '12345678'
      click_button "Log in"
      assert_selector "h1", text: "Authenticate your account"
      assert_selector "p", text: "Enter 6-digit code from your two factor authenticator app."

      fill_in_digit_fields_with '111111'
      click_button "Verify"
      assert_content "Failed to authenticate your code"

      token = get_an_onetime_token_from_authenticator_app(@hopper)
      fill_in_digit_fields_with token
      click_button "Verify"
      assert_selector "h1", text: "Dashboard"
      assert_equal dashboard_path, page.current_path
    end

    ##############################
    ## Login with a backup code ##
    ##############################
    click_on "Logout"
    assert_content "Signed out successfully."

    click_on "Login"
    assert_selector "h2", text: "Log in"

    fill_in 'Email', with: 'hopper@example.com'
    fill_in 'Password', with: '12345678'
    click_button "Log in"
    assert_selector "h1", text: "Authenticate your account"
    assert_selector "p", text: "Enter 6-digit code from your two factor authenticator app."

    click_link "Use a recovery code to access your account."
    assert_selector "h1", text: "Authenticate your account with a recovery code"
    assert_selector "p", text: "To access your account, enter one of the recovery codes you saved when you set up your two-factor authentication device."

    fill_in_digit_fields_with '1234abcd'
    click_button "Verify"
    assert_content "Failed to authenticate your code"

    fill_in_digit_fields_with @recovery_codes.pop
    click_button "Verify"
    assert_selector "h1", text: "Dashboard"
    assert_equal dashboard_path, page.current_path
  end

  def save_recovery_codes
    @recovery_codes = all("li").map(&:text)
  end

end