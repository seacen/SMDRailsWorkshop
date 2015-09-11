class SessionsController < ApplicationController

  # Before actions to check paramters
  before_action :check_params, only: [:login]
  before_action :authenticate_user, only: [:logout]

  def unauth
  end

  # Find a user with the username and email pair, log in that user if they exist
  def login
  	# Find a user with params
  	user = User.find_by(username: @credentials[:username])
  	if user && user.authenticate(@credentials[:password])
	  	# Save them in the session
	  	log_in user
	  	# Redirect to posts page
	  	redirect_to posts_path
	else
		redirect_to :back
	end
  end

  # Log out the user in the session and redirect to the unauth thing
  def logout
  	log_out
  	redirect_to login_path
  end

  # Private controller methods
  private
  def check_params
  	params.require(:credentials).permit(:username, :password)
  	@credentials = params[:credentials]
  end

end
