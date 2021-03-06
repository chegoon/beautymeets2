json.header "Profile"
json.id @user.id
json.name @user.username
json.email @user.email
json.getPushNotifications @user.get_push_notifications
json.thumbUrl full_url(@user.image_url)

json.gender Gender.find(@member.gender_id).name if @member.gender_id 
json.yearOfBirth @member.year_of_birth
json.eyeTypes @member.eye_types.map(&:name)
json.skinTypes @member.skin_types.map(&:name)
json.skinBrightnesses @member.skin_brightnesses.map(&:name)
json.skinColors @member.skin_colors.map(&:name)
json.skinTones @member.skin_tones.map(&:name)
json.skinTroubles @member.skin_troubles.map(&:name)
