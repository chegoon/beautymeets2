json.header "My Page"
json.id @user.id
json.name @user.username ? @user.username : @user.email
json.thumbUrl full_url(@user.image_url)