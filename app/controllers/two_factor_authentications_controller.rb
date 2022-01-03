class TwoFactorAuthenticationsController < ApplicationController
  def show
  end

  def create
    current_user.otp_secret = User.generate_otp_secret
    current_user.save!

    @qrcode = current_user.otp_qrcode
    render 'two_factor_authentication/confirmations/new'
  end

  def destroy
    current_user.otp_required_for_login = false
    current_user.otp_backup_codes&.clear
    current_user.save!
    redirect_to two_factor_authentication_path
  end
end
