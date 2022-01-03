module Devise
  module Strategies
    class RecoveryCodeAuthenticatable < Devise::Strategies::Base

      def authenticate!
        resource = mapping.to.find(session[:otp_user_id])

        if validate_recovery_code(resource)
          session[:otp_user_id] = nil
          session[:otp_user_id_expires_at] = nil
          success!(resource)
        else
          fail!('Failed to authenticate your code')
        end
      end

      private

      def validate_recovery_code(resource)
        return true unless resource.otp_required_for_login
        return if params[scope]['recovery_code'].nil?
        resource.invalidate_otp_backup_code!(params[scope]['recovery_code'])
      end

    end
  end
end

Warden::Strategies.add(:recovery_code_authenticatable, Devise::Strategies::RecoveryCodeAuthenticatable)