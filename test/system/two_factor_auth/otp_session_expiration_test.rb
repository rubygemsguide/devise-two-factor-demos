require 'application_system_test_case'

class OTPSessionExpiration < ApplicationSystemTestCase

  setup do
    @hopper = users(:hopper)
    setup_2fa(@hopper)
  end

  test "expire after 30 seconds on OTP login page" do
    visit root_path
    assert_content "Welcome to 2FA Demo!"

    click_on "Login"
    assert_selector "h2", text: "Log in"

    fill_in "Email", with: "hopper@example.com"
    fill_in "Password", with: "12345678"
    click_button "Log in"
    assert_selector "h1", text: "Authenticate your account"
    assert_selector "p", text: "Enter 6-digit code from your two factor authenticator app."

    refresh
    assert_selector "h1", text: "Authenticate your account"
    assert_selector "p", text: "Enter 6-digit code from your two factor authenticator app."
    assert_equal "/users/sign_in/otp", page.current_path

    travel_to 31.seconds.after do
      refresh
      assert_selector "h2", text: "Log in"
      assert_equal "/users/sign_in", page.current_path
    end
  end

  test "expire after 30 seconds on recovery codee login page" do
    visit root_path
    assert_content "Welcome to 2FA Demo!"

    click_on "Login"
    assert_selector "h2", text: "Log in"

    fill_in "Email", with: "hopper@example.com"
    fill_in "Password", with: "12345678"
    click_button "Log in"
    assert_selector "h1", text: "Authenticate your account"
    assert_selector "p", text: "Enter 6-digit code from your two factor authenticator app."

    click_link "Use a recovery code to access your account."
    assert_selector "h1", text: "Authenticate your account with a recovery code"
    assert_selector "p", text: "To access your account, enter one of the recovery codes you saved when you set up your two-factor authentication device."

    refresh
    assert_selector "h1", text: "Authenticate your account with a recovery code"
    assert_selector "p", text: "To access your account, enter one of the recovery codes you saved when you set up your two-factor authentication device."
    assert_equal "/users/sign_in/recovery_code", page.current_path

    travel_to 31.seconds.after do
      refresh
      assert_selector "h2", text: "Log in"
      assert_equal "/users/sign_in", page.current_path
    end
  end

end