class Item < ActiveRecord::Base

	is_impressionable
	
	include PublicActivity::Common

	resourcify
	include Authority::Abilities

	acts_as_taggable

	acts_as_commentable
	
	acts_as_readable :on => :updated_at

	extend FriendlyId
	friendly_id :url_candidate, use: [:slugged, :history]
	
	belongs_to :brand
	attr_accessible :description, :name, :view_count, :brand_name, :tag_list, :picture_id,  :category_ids, :url_candidate, :collection_title
	
	has_many :pictures, as: :pictureable, dependent: :destroy

	belongs_to :thumbnail, class_name: "Picture", :foreign_key => "picture_id"

	has_many :itemizations, dependent: :destroy  
	belongs_to :itemizable, polymorphic: true

	has_many :tutorials, through: :itemizations, source: :itemizable, source_type: 'Tutorial'
	has_many :videos, through: :itemizations, source: :itemizable, source_type: 'Video'
	
	has_many :comments, :as => :commentable

	has_many :categories, through: :categorizations
	has_many :categorizations, as: :categorizeable  

	has_many :collections, through: :collectings
	has_many :collectings, as: :collectable  

	def increment_view_count(by = 1)
		self.view_count ||= 0
		self.view_count += by
		self.save
	end

	def collection_title
		self.collections.find_by_title(:title)
	end

	def collection_title=(title)
		collection = Collection.find_by_title(title)
		if collection.present? 
			collecting = self.collectings.find_by_collection_id(collection.id) || self.collectings.create(collection_id: collection.id) 
		else
			collection = self.collections.create(title: title)
		end
	end

	def brand_name
		#brand.name if brand
		brand.try(:name)
	end
		
	def brand_name=(name)
		self.brand = Brand.find_or_create_by_name(name) if name.present?
	end

	def author
		# return admin 
		return User.find(4)
	end

	def title
		return name
	end
	# Method for bookmark
	def self.get_title(id)
		#self.try(:name)
		(find_by_slug(id) || find_by_id(id)).name
	end

	def self.get_description(id)
		(find_by_slug(id) || find_by_id(id)).description
	end
	
	def self.find_id_by_site_url(site_url)
		url = site_url.split(%r{/})
		(find_by_slug(url[2]) && find_by_slug(url[2]).id) || site_url.split(%r{/})[2]
	end

	def reply_enabled 
		return false
	end
end