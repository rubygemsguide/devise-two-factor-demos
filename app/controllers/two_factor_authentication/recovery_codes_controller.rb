class TwoFactorAuthentication::RecoveryCodesController < ApplicationController
  def create
    @recovery_codes = current_user.generate_otp_backup_codes!
    current_user.save!
    render :index
  end
end