class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :ensure_signup_complete
  before_action :cookieMe
  before_action :specifyLanguage

  before_filter :configure_permitted_parameters, if: :devise_controller?

  # Require for social authentication
  def ensure_signup_complete
    # Ensure we don't go into an infinite loop
    return if action_name == 'finish_signup'

    # Redirect to the 'finish_signup' page if the user
    # email hasn't been verified yet
    if user_signed_in? && current_user && ( !current_user.email_verified?() || !current_user.username_verified?())
      redirect_to finish_signup_path(current_user)
    end
  end

  # If the user is logged, we put some information into the cookies to allow Ajax call
  def cookieMe
    if user_signed_in?
      cookies[:user_id] = current_user.id
      cookies[:user_token] = current_user.salt
      cookies[:user_username] = current_user.username
      cookies[:language] = current_user.language
    elsif !user_signed_in?()
      cookies.delete :user_id
      cookies.delete :user_token
      cookies.delete :user_username
    end
  end

  # Prepare the pages for the multi-language
  def specifyLanguage
    l = Language.all
    l_list = []
    l.each do |language|
      l_list << language.abbreviation
    end
    if (user_signed_in?)
      @languageSelected = current_user.language
    elsif (cookies.has_key?(:language) && l_list.include?(cookies[:language]))
      @languageSelected = cookies[:language]
    else
      @languageSelected = "EN"
      cookies[:language] = "EN"
    end
  end

  protected
    # For some protection with Devise
    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:email, :password, :fname, :lname, :username, :birthday, :image, :newsletter, :language) }
      devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:email, :password, :fname, :lname, :username, :birthday, :image, :description, :phoneNumber, :facebook, :twitter, :googlePlus, :newsletter, :language) }
    end
end
