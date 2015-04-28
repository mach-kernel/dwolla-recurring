require 'dwolla'

class DashboardController < ApplicationController
	def home
	end
	
	# Scheduled Transactions
	def create
		@fs = []
		DwollaVars.Dwolla::FundingSources.get(nil, session[:oauth_token]).each do |h|
			@fs.push([h['Name'], h['Id']])
		end
	end

	def manage
		if params[:id]
			@transaction = DwollaVars.Dwolla::Transactions.scheduled_by_id(params[:id], session[:oauth_token])

			@fs = []
			DwollaVars.Dwolla::FundingSources.get(nil, session[:oauth_token]).each do |h|
				@fs.push([h['Name'], h['Id']])
			end

			render 'edit'
		else
			@scheduled = DwollaVars.Dwolla::Transactions.scheduled({}, session[:oauth_token])['Results']
			render 'manage'
		end
	end

	def delete
		if not params[:delete]
			flash[:error] = "You've arrived here in error. Sorry!"
			redirect_to '/dashboard/manage'
		else
			DwollaVars.Dwolla::Transactions.delete_scheduled_by_id(params[:delete][:Id], {:pin => params[:delete][:pin]}, session[:oauth_token])
			flash[:success] = "You've successfully deleted the scheduled transaction"
			redirect_to '/dashboard/manage'
		end
	end

	def process_scheduled
		if params[:commit] == "Create"
			# If you name all of your form parameters by the 
			# parameters which the gem expects, you do not need
			# to create another hash.
			DwollaVars.Dwolla::Transactions.schedule(params[:scheduled], session[:oauth_token])

			flash[:success] = "The scheduled transaction has been succesfully created!"
			redirect_to '/'
		elsif params[:commit] == "Edit"
			DwollaVars.Dwolla::Transactions.edit_scheduled(params[:scheduled][:Id], params[:scheduled].except!(:Id), session[:oauth_token])

			flash[:success] = "The scheduled transaction has been succesfully edited!"
			redirect_to '/dashboard/manage'
		end

	end

	# Session Management

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
			session[:name] = DwollaVars.Dwolla::Users.me(session[:oauth_token])['Name']

			# Make user happy
			flash[:success] = "You have been successfully logged in!"
			redirect_to "/"
		end
	end

	def logout
		# Destroy the rails session hash
		reset_session
	    flash[:alert] = "You have logged out."
	    redirect_to "/"
	end
end
