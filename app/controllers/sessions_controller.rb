class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      flash[:success] = "You have logged in!"
      log_in(user)
      redirect_to user
    else
      flash.now[:danger] = 'Email or password incorrect. Try again.'
      render 'new'
    end
  end

  def destroy
  end
end
