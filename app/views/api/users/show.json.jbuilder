json.header "Profile"
json.id @user.id
json.name @user.username

json.gender Gender.find(@member.gender_id).name if @member.gender_id # 1: female, 2:male
json.yearOfBirth @member.year_of_birth
json.skinTypes @member.skin_type_list #Member.tag_counts_on("skin_types")
json.skinBrightnesses @member.skin_brightness_list #Member.tag_counts_on("skin_brightnesses")
json.skinColors @member.skin_color_list #Member.tag_counts_on("skin_colors") #
json.skinTones @member.skin_tone_list #Member.tag_counts_on("skin_tones") #
json.skinTroubles @member.skin_trouble_list #Member.tag_counts_on("skin_troubles") #
