class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy, :finish_signup]
  before_action :no_content, only: [:index, :show, :friendlist]

  def no_content
    render :text => "", :layout => true
  end

  # GET /users/:id.:format
  def show
  end

  # GET /users/:id/edit
  def edit
    # authorize! :update, @user
    respond_to do |format|
      if (!(user_signed_in? && params[:id].to_i == current_user.id))
        format.html { redirect_to root_path }
        format.json { render :json => {}, status: :forbidden }
      else
        set_user
        format.html { render :text => "", :layout => true }
        format.json { render :json => @user.as_json(except: [:salt, :password, :idAPI, :secureKey, :created_at, :updated_at, :address_id], :include => {
            :address => { :only => Address.miniKey },
            :identities => {}
          }) }
      end
    end
  end

  # GET/PATCH /users/:id/finish_signup
  def finish_signup
    if current_user && ( current_user.email_verified?() && current_user.username_verified?())
      redirect_to root_path
    # authorize! :update, @user 
    elsif request.patch? && params[:user]
      @user.skip_reconfirmation!
      if @user.update(User.user_params params)
        @user.skip_reconfirmation!
        redirect_to @user, notice: 'Your profile was successfully updated.'
      else
        @show_errors = true
      end
    end
  end

  def friendlist
  end
  
  private
    def set_user
      if (params[:id].to_s =~ /\A[-+]?\d*\.?\d+\z/)
        @user = User.find_by_id(params[:id].to_s)
      else
        @user = User.find_by_username(params[:id].to_s)
      end
    end
end