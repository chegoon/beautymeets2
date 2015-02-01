class Video < ActiveRecord::Base
	is_impressionable
	
	include PublicActivity::Common

	resourcify
	include Authority::Abilities

	acts_as_taggable

	acts_as_commentable
	
	acts_as_readable :on => :updated_at
	
	extend FriendlyId
	friendly_id :title, use: :slugged
	
	belongs_to :video_group
	
	attr_accessible :description, :title, :view_count, :thumb_url, :title, :video_url, :video_group_id, :image, :published, :category_ids, :published_at, :duration, :tag_list, :collection_title, :item_name

	has_many :categorizations, as: :categorizeable
	has_many :categories, through: :categorizations
	
	has_many :items, through: :itemizations
	has_many :itemizations, as: :itemizable

	has_many :collections, through: :collectings
	has_many :collectings, as: :collectable  
	
	has_many :comments, :as => :commentable
	
	mount_uploader :image, ImageUploader

	def thumbnail
		self
	end

	def author
		video_group
	end

	def item_name
		self.items.find_by_name(:name)
	end

	def item_name=(name)
		item = Item.find_by_name(name)
		if item.present? 
			itemization = self.itemizations.find_by_item_id(item.id) || self.itemizations.create(item_id: item.id) 
		else
			item = self.items.create(name: name)
		end
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

	def group_name
		video_group.try(:name)
	end
		
	def group_name=(name)
		self.video_group = VideoGroup.find_or_create_by_name(name) if name.present?
	end

	def increment_view_count(by = 1)
		self.view_count ||= 0
		self.view_count += by
		self.save
	end
	
	def most_popular_in_categories(category)
		#puts "recommendations begin"
		if !category.nil?
			return Video.joins(:video_group, :categories).where("video_groups.published=TRUE AND videos.published=TRUE AND categories.id = ? AND videos.id != ?", category.id, self.id).order("view_count DESC LIMIT 10").sample(4)
		else
			return Video.joins(:video_group, :categories).where("video_groups.published=TRUE AND videos.published=TRUE AND categories.id IN (?) AND videos.id != ?", self.categories.map(&:id), self.id).order("view_count DESC").limit(10).sample(4)
		end
	end

	def latest_in_categories(category)
		#puts "recommendations begin"
		if !category.nil?
			return Video.joins(:video_group, :categories).where("video_groups.published=TRUE AND videos.published=TRUE AND categories.id = ? AND videos.id != ?", category, self.id).order("created_at DESC LIMIT 10").sample(4)
		else
			return Video.joins(:video_group, :categories).where("video_groups.published=TRUE AND videos.published=TRUE AND categories.id IN (?) AND videos.id != ?", self.categories.map(&:id), self.id).order("created_at DESC").limit(10).sample(4)
		end
	end

	def most_popular_in_groups
		#puts "recommendations begin"
		return self.video_group.videos.where("published=TRUE AND videos.id != ?",  self.id).order("view_count DESC LIMIT 10").sample(3)
	end

	def latest_in_groups
		#puts "recommendations begin"
		return self.video_group.videos.where("published=TRUE  AND videos.id != ?", self.id).order("created_at DESC LIMIT 10").sample(3)
	end
=begin
	def recommendations
		#puts "recommendations begin"
		return Video.joins(:video_categories).where("published=TRUE AND video_categories.id IN (?) AND videos.id != ?", self.video_categories.map(&:id), self.id).order("view_count DESC LIMIT 50").sample(3)
	end
=end
	# Method for bookmark
	def self.get_title(id)
		#self.try(:name)
		(find_by_slug(id) || find_by_id(id)).title
	end

	def self.get_description(id)
		(find_by_slug(id) || find_by_id(id)).description
	end
	
	def self.find_id_by_site_url(site_url)
		url = site_url.split(%r{/})
		(find_by_slug(url[2]) && find_by_slug(url[2]).id) || site_url.split(%r{/})[2]
	end
	def reply_enabled 
		return true
	end
end
