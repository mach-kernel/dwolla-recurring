require 'dwolla'

class DashboardController < ApplicationController
	def home
	end
	
	def login
		redirect_to DwollaVars.Dwolla::OAuth.get_auth_url(DwollaVars.redirect)
	end

	def handle_oauth
		if not params['code'] 
			flash[:error] = "There was an issue logging in with Dwolla. Try again later."
			redirect_to "/"
		else
			# Set access token
			session[:oauth_token] = DwollaVars.Dwolla::OAuth.get_token(params['code'], DwollaVars.redirect)['access_token']

			# Set name, for aesthetics.
			session[:name] = DwollaVars.Dwolla::Users.me(token=session[:oauth_token])['Name']

			flash[:success] = "You have been successfully logged in!"
			redirect_to "/"
		end
	end

	def logout
		reset_session
	    flash[:alert] = "You have logged out."
	    redirect_to "/"
	end
end
