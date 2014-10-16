json.header "Profile"
json.id @user.id
json.name @user.username

if params[:sub] == "basic" 
	json.basicVisible "true"

	json.basic do 
		json.genders Gender.all.each do |g|
			json.id g.id
			json.name g.name
			if g.id == @member.gender_id
				json.checked true
			end
		end
		json.yearOfBirth @member.year_of_birth
	end

elsif params[:sub] == "skinTypes" 
	json.skinTypeVisible "true"

	json.skinTypes Member.tag_counts_on("skin_types").each do |tag|
		json.id tag.id
		json.name tag.name
		@member.skin_types.each do |type|
			if tag.id == type.id
				json.checked true
			end
		end
	end

elsif params[:sub] == "skinBrightnesses" 
	json.skinBrightnessVisible "true"
	json.skinBrightnesses Member.tag_counts_on("skin_brightnesses").each do |tag|
		json.id tag.id
		json.name tag.name
		@member.skin_brightnesses.each do |type|
			if tag.id == type.id
				json.checked true
			end
		end
	end

elsif params[:sub] == "skinTones" 
	json.skinToneVisible "true"
	json.skinTones Member.tag_counts_on("skin_tones").each do |tag|
		json.id tag.id
		json.name tag.name
		@member.skin_tones.each do |type|
			if tag.id == type.id
				json.checked true
			end
		end
	end

elsif params[:sub] == "skinColors" 
	json.skinColorVisible "true"
	json.skinColors Member.tag_counts_on("skin_colors").each do |tag|
		json.id tag.id
		json.name tag.name
		@member.skin_colors.each do |type|
			if tag.id == type.id
				json.checked true
			end
		end
	end

elsif params[:sub] == "skinTroubles" 
	json.skinTroubleVisible "true"
	json.skinTroubles Member.tag_counts_on("skin_troubles").each do |tag|
		json.id tag.id
		json.name tag.name
		@member.skin_troubles.each do |type|
			if tag.id == type.id
				json.checked true
			end
		end
	end
else
end