class PushNotification < ActiveRecord::Base

  attr_accessible :body, :sent, :title, :url

	acts_as_taggable_on :skin_types, :skin_troubles, :skin_tones, :skin_brightnesses, :skin_colors, :eye_types
	attr_accessible :skin_type_list, :eye_type_list, :skin_trouble_list, :skin_tone_list, :skin_brightness_list, :skin_color_list

  resourcify
  include Authority::Abilities
  self.authorizer_name = "AdminAuthorizer"

end
