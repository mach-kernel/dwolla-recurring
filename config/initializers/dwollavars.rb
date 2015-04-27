require 'dwolla'

module DwollaVars
	mattr_reader  :Dwolla, :redirect

	@@key ||= "OFvc0S1ccEhgI/qJleEsIQQBdb3/mReQMkaNQmFbbo8PaAAtYI"
	@@secret ||= "oi6jXUSXVN1MuB0YT6X5WV/Alhv9MZdtDLSd71h6HOLRpu6fSf"

	@@redirect ||= "http://localhost:3000/dashboard/handle_oauth"

	@@Dwolla ||= Dwolla
	@@Dwolla::api_key ||= @@key
	@@Dwolla::api_secret ||= @@secret
	@@Dwolla::sandbox ||= true
end