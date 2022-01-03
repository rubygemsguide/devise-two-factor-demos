class TwoFactorAuthentication::ConfirmationsController < ApplicationController
  def create
    if current_user.validate_and_consume_otp!(params.dig(:otp_code))
      current_user.otp_required_for_login = true
      current_user.save!
  
      render "two_factor_authentication/confirmations/success"
    else
      flash.now[:alert] = "Failed to confirm the 2FA code"
      prepare_2fa_form
      render :new
    end
  end
end
