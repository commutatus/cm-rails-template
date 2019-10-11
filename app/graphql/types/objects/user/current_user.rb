module Types
	module Objects
		module User
			class CurrentUser < Base
				field :created_at,									Types::Objects::DateTime, nil, 	null: false
				field :confirmed_at,								Types::Objects::DateTime, nil, 	null: true
				field :email,												String, 									nil,	null: false
				field :last_name, 									String, 									nil, 	null: false
			end
		end
	end
end
