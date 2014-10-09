json.success true
json.info "Logged in"
json.params do
	json.user_id @authentication.user.id
	json.email @authentication.user.email
	json.user_name @authentication.user.name
	json.authToken @authentication.user.authentication_token
end