json.success true
json.info "Logged in"
json.params do
	json.user_id @auth.user.id
	json.user_name @auth.user.name
	json.authToken @auth.user.authentication_token
end