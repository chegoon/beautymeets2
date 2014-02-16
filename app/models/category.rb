class Category < ActiveRecord::Base
  include ActsAsTree

  resourcify
  include Authority::Abilities

  acts_as_tree order: "name"
  
  extend FriendlyId
  friendly_id :name, use: :slugged

  attr_accessible :name, :parent_id, :parent_name

  belongs_to :parent, :class_name => 'Category'
  has_many :children, :class_name => 'Category', :foreign_key => "parent_id"

  has_many :categorizations
  belongs_to :categorizable, polymorphic: true
  has_many :videos, through: :categorizations, source: :categorizable, source_type: 'Video'
  has_many :tutorials, through: :categorizations, source: :categorizable, source_type: 'Tutorial'
  has_many :members, through: :categorizations, source: :categorizable, source_type: 'Member'

  def parent_name 
  	parent.name if parent
  end

	def parent_name=(name)
	  self.parent = Category.find_or_create_by_name(name) unless name.blank?
	end


  def children
    Category.where("parent_id = ?", self.id).all
  end
=begin
  def videos
    if self.parent.nil?
      children = VideoCategory.where("parent_id = ?", self.id)
      if children.present?
        return VideoCategory.where("id IN (?)", children.map(&:id)).videos.where("published=TRUE")
      else
        return self.videos.where("published=TRUE").all  
      end
    else
      return self.videos.where("published=TRUE").all
    end

  end
=end
  def videos_count
    if self.parent.nil?
      child_categories = Category.where("parent_id = ?", self.id)
      cnt = 0
      child_categories.each do |cat|
        cnt = cnt + cat.videos.where("published=TRUE").count
      end
      if cnt == 0
        return self.videos.where("published=TRUE").count
      else
        return cnt
      end
    else
      return self.videos.where("published=TRUE").count
    end
  end
  
  def increment_view_count(by = 1)
    self.view_count ||= 0
    self.view_count += by
    self.save
  end

end
