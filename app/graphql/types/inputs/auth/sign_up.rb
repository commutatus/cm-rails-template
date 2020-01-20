module Types
	module Inputs
		module Auth
			class SignUp < Types::BaseInputObject
				description "Attributes for creating a user"

				argument :email, 												String, 	nil, 	required: true
				argument :first_name, 									String, 	nil, 	required: true
				argument :last_name, 										String, 	nil, 	required: true
				argument :password, 										String, 	nil, 	required: true
				argument :mobile_number,									String,		nil, 	required: false
			end
		end
	end
end
