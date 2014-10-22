json.header "Profile"
json.id @user.id
json.name @user.username

json.gender Gender.find(@member.gender_id).name if @member.gender_id 
json.yearOfBirth @member.year_of_birth
json.skinTypes @member.skin_types.map(&:name)
json.skinBrightnesses @member.skin_brightnesses.map(&:name)
json.skinColors @member.skin_colors.map(&:name)
json.skinTones @member.skin_tones.map(&:name)
json.skinTroubles @member.skin_troubles.map(&:name)
