class User < ActiveRecord::Base
	before_save :ensure_authentication_token!

	def ensure_authentication_token!
		if authentication_token.blank?
			self.authentication_token = generate_authentication_token
		end
	end

	def generate_authentication_token
		loop do
			token = generate_secure_token_string
			break token unless User.where(authentication_token: token).first
		end
	end

	def generate_secure_token_string
		SecureRandom.urlsafe_base64(25).tr('lIO0', 'sxyz')
	end
	
	def reset_authentication_token!
		self.authentication_token = generate_authentication_token
	end
=begin
	# Sarbanes-Oxley Compliance: http://en.wikipedia.org/wiki/Sarbanes%E2%80%93Oxley_Act
	def password_complexity
		if password.present? and not password.match(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W]).+/)
			errors.add :password, "must include at least one of each: lowercase letter, uppercase letter, numeric digit, special character."
		end
	end

	def password_presence
		password.present? && password_confirmation.present?
	end

	def password_match
		password == password_confirmation
	end
=end
	# reg. controller에서 직접 add_role 호출
	#after_create :assign_member_role
	#after_create :welcome
	acts_as_voter
	acts_as_reader
	
	rolify
	include Authority::UserAbilities
	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable and :omniauthable
	devise :database_authenticatable, :registerable, :confirmable, 
				 :recoverable, :rememberable, :trackable, :validatable, :omniauthable#, :token_authenticatable#, :authentication_keys => [:email]#, :omniauth_providers => [:facebook]

	# Setup accessible (or protected) attributes for your model
	attr_accessible :current_password, :email, :password, :password_confirmation, :remember_me, :username, :image, :remote_image_url, :authentication_token, :get_push_notifications
	attr_accessor :current_password

	belongs_to :profile, polymorphic: true, dependent: :destroy
	has_many :tutorials
	has_many :beautyclasses
	has_many :notices,  :dependent => :destroy
	has_many :checkouts,  :dependent => :destroy
	has_many :bookmarks,  :dependent => :destroy
	has_many :authentications,  :dependent => :destroy
	has_many :posts
	has_many :boards,  :dependent => :destroy
	has_many :devices, dependent: :destroy
	has_many :collections
	has_many :comments,  :dependent => :destroy
	
	has_many :events, through: :event_entrys
	has_many :event_entrys
	#validates :username, uniqueness: {case_sensitive: true}

=begin
	validates :email, 
          :presence => true, 
          :format => { :with => VALID_EMAIL_REGEX }, 
          :uniqueness => {:case_sensitive => false },
          :if => 'provider.blank?'
=end
	mount_uploader :image, ImageUploader

	def name
		self.try(:username)
	end
		
	def name=(u_name)
		self.username = u_name if u_name.present?
	end

# The below method was used before authentication model created
=begin
	def self.from_omniauth(auth)
		where(auth.slice(:provider, :uid)).first_or_create do |user|
			user.provider = auth.provider
			user.uid = auth.uid
			user.username = auth.info.name
		end
	end
=end

	def apply_omniauth(omniauth)
		#puts "omniauth #{omniauth}"
		self.email = omniauth['info']['email'] if email.blank?
		self.username = omniauth['info']['name'] if username.blank?
		self.remote_image_url = omniauth['info']['image'] if remote_image_url.blank?
		authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid'], :oauth_token => omniauth['credentials']['token'], :oauth_token_secret => omniauth['credentials']['secret'])
		puts "authentication built"
	end

	# new_with_session is used in build_resource. 
	# This is used with registerable (user regsitration forms). 
	# This is only useful when your Facebook/Omniauth session already exists and you want to prefill your Registration form with some data from omniauth. 
	# (assuming you didn't already create the account automatically on callback)
	def self.new_with_session(params, session)
		if session["devise.user_attributes"]
			new(session["devise.user_attributes"], without_protection: true) do |user|
				user.attributes = params
				user.valid?
			end
		else
			super
		end    
	end

	def email_required?
		super && authentications.empty?
	end

	# if user regists through omniauth, user be able to pass password field
	def password_required?
		(authentications.empty? || !password.blank?) && super
	end
	
	# if user regsits through omniauth, user can update their profile with password or without password
	def update_with_password(params, *options)
		if encrypted_password.blank?
			update_attributes(params, *options)
		else
			super
		end
	end

	def facebook
		fb_auth = self.authentications.find_by_provider("facebook")
		@facebook ||= Koala::Facebook::API.new(fb_auth.oauth_token)
	end

	# Not to send confirmation mail even if confirmable
	protected
	def confirmation_required?
		false
	end
=begin	
	def self.find_for_authentication(conditions={})
		find(:first, conditions: { users: { email: conditions.delete(:email) } })
	end
=end
=begin
	def assign_member_role
		self.add_role :member
	end
=end
=begin
	private
	def welcome
		UserMailer.welcome(self).deliver
	end
=end
end
