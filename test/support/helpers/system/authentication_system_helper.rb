module AuthenticationSystemHelper
  def scan_the_qr_code_and_get_an_onetime_token(user)
    user.reload.current_otp
  end

  def get_an_onetime_token_from_authenticator_app(user)
    user.reload.current_otp
  end

  def fill_in_digit_fields_with(number)
    chars = number.to_s.split('')

    chars.each.with_index do |char, index|
      fill_in "digit-#{index + 1}", with: char
    end
  end

  def setup_2fa(user)
    user.otp_secret = User.generate_otp_secret
    user.otp_required_for_login = true
    user.generate_otp_backup_codes!
    user.save!
  end
end