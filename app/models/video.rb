class Video < ActiveRecord::Base

  include PublicActivity::Common

  resourcify

  acts_as_taggable

  acts_as_commentable
  
  acts_as_readable :on => :created_at
  
  extend FriendlyId
  friendly_id :title, use: :slugged
  
  belongs_to :video_group
  
  attr_accessible :description, :title, :view_count, :thumb_url, :title, :video_url, :video_group_id, :image, :published, :category_ids, :published_at, :duration, :tag_list

  has_many :categorizations, as: :categorizeable
  has_many :categories, through: :categorizations
  
  has_many :itemization, as: :itemizable
  has_many :items, through: :itemization
  
  has_many :comments, :as => :commentable
  
  mount_uploader :image, ImageUploader

  def thumbnail
  	self
  end
	def group_name
	  	#brand.name if brand
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
			return Video.joins(:categories).where("published=TRUE AND categories.id = ? AND videos.id != ?", category.id, self.id).order("view_count DESC LIMIT 10").sample(3)
		else
			return Video.joins(:categories).where("published=TRUE AND categories.id IN (?) AND videos.id != ?", self.categories.map(&:id), self.id).order("view_count DESC").limit(10).sample(3)
		end
	end

	def latest_in_categories(category)
		#puts "recommendations begin"
		if !category.nil?
			return Video.joins(:categories).where("published=TRUE AND categories.id = ? AND videos.id != ?", category, self.id).order("created_at DESC LIMIT 10").sample(3)
		else
			return Video.joins(:categories).where("published=TRUE AND categories.id IN (?) AND videos.id != ?", self.categories.map(&:id), self.id).order("created_at DESC").limit(10).sample(3)
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
end
