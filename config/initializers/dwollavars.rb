require 'dwolla'

module DwollaVars
	mattr_reader  :Dwolla, :redirect

	@@key ||= "rhfI4mFE8JqAQolQdRyqUGrdzHif9qi72ST/Zhq5p38YxrF1rZ"
	@@secret ||= "2zd9liH0d5LErdI6qMO5l/nk0PRydu+7TJ+S+dnIbhgTYeX4sD"

	@@redirect ||= "https://dwolla-recurring-heroku.herokuapp.com/dashboard/handle_oauth"

	@@Dwolla ||= Dwolla
	@@Dwolla::api_key ||= @@key
	@@Dwolla::api_secret ||= @@secret
	@@Dwolla::sandbox ||= false
end
