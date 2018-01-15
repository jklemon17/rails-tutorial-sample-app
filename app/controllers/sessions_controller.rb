class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user && @user.authenticate(params[:session][:password])
      if @user.activated
        flash[:success] = "You have logged in!"
        log_in(@user)
        params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
        redirect_back_or(@user)
      else !@user.activated
        flash[:warning] = "Account not activated. Please check your email for activation link."
        redirect_to(root_url)
      end
    else
      flash.now[:danger] = 'Email or password incorrect. Try again.'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    flash[:success] = "You have logged out"
    redirect_to root_path
  end
end
