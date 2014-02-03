class Authentication < ActiveRecord::Base
  belongs_to :user
  attr_accessible :provider, :uid, :oauth_token, :oauth_token_secret
end
