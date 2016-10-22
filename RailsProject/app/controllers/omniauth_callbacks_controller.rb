class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def self.provides_callback_for(provider)
    class_eval %Q{
      def #{provider}
        @user = User.find_for_oauth(env["omniauth.auth"], current_user)

        if @user.persisted?
          sign_in_and_redirect @user, event: :authentication
          set_flash_message(:notice, :success, kind: "#{provider}".capitalize) if is_navigational_format?
        else
          session["devise.#{provider}_data"] = env["omniauth.auth"].except("extra")
          redirect_to new_user_session_url
        end
      end
    }
  end

  [:twitter, :facebook, :google].each do |provider|
    provides_callback_for provider
  end

  def after_sign_in_path_for(resource)
    if resource.email_verified? && resource.username_verified?
      super resource
    else
      if (resource.flash != nil)
        resource.flash.each { |key, value|
          flash[key] = value
        }
        resource.flash = nil
      end
      finish_signup_path(resource)
    end
  end
end
