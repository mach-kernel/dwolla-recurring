require 'dwolla'

class DashboardController < ApplicationController
	def home
	end
	
	# Scheduled Transactions
	def create
		unless logged_in?
			flash[:error] = "Easy there! Log in first!"
			redirect_to '/'
		end		
		
		@fs = []
		DwollaVars.Dwolla::FundingSources.get(nil, session[:oauth_token]).each do |h|
			@fs.push([h['Name'], h['Id']])
		end
	end

	def manage
		unless logged_in?
			flash[:error] = "Easy there! Log in first!"
			redirect_to '/'
		end

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
			weekly_recurrence = ""

			weekly_recurrence << "1," if params[:scheduled][:mon]
			weekly_recurrence << "2," if params[:scheduled][:tue]
			weekly_recurrence << "3," if params[:scheduled][:wed]
			weekly_recurrence << "4," if params[:scheduled][:thu]
			weekly_recurrence << "5," if params[:scheduled][:fri]
			weekly_recurrence << "6," if params[:scheduled][:sat]
			weekly_recurrence << "7" if params[:scheduled][:sun]

			unless weekly_recurrence.empty?
				params[:scheduled][:Recurrence] = {:frequency => 'weekly', :onDays => "#{}"}
			end
			
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
