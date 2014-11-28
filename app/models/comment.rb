class Comment < ActiveRecord::Base
  include PublicActivity::Common
  # model에서 콜백 메소드를 이용하여 activity 메소들을 정의할때 사용
  #tracked only: :create, owner: ->(controller, model) { controller && controller.current_user }, recipient: 
  #tracked only: :create, owner: :author, recipient: #recipient: :commentable #commentable 에서 user로 수정(2014.04.21)
  #tracked only: :create, owner: Proc.new{ |controller, model| controller && controller.current_user }, recipient: :commentable

  DEFAULT_PAGE_SIZE = 7

  acts_as_votable

  resourcify
  include Authority::Abilities
  self.authorizer_name = "BasicAuthorizer"
  
  mount_uploader :image, ImageUploader
  
  acts_as_nested_set :scope => [:commentable_id, :commentable_type]
  
  validates :body, :presence => true
  validates :user, :presence => true

  # NOTE: install the acts_as_votable plugin if you
  # want user to vote on the quality of comments.
  #acts_as_votable
  
  #has_many :pictures, as: :pictureable, dependent: :destroy
  has_one :picture, as: :pictureable, dependent: :destroy
  accepts_nested_attributes_for :picture, allow_destroy: true, :reject_if => lambda { |a| a['image'].blank? }

  belongs_to :commentable, :polymorphic => true
  attr_accessible :commentable, :body, :user_id, :picture_attributes

  # NOTE: Comments belong to a user
  belongs_to :user #:author, class_name: "User", :foreign_key => "user_id"
  
  # Helper class method that allows you to build a comment
  # by passing a commentable object, a user_id, and comment text
  # example in readme
  def self.build_from(obj, user_id)#, comment, picture_attributes)
    new \
      :commentable => obj,
      :user_id     => user_id
      #:body        => comment,
      #:pictureable => self,
      #:picture_attributes => picture_attributes
  end

  #helper method to check if a comment has children
  def has_children?
    self.children.any?
  end

  # Helper class method to lookup all comments assigned
  # to all commentable types for a given user.
  scope :find_comments_by_user, lambda { |user|
    where(:user_id => user.id).order('created_at DESC')
  }

  # Helper class method to look up all comments for
  # commentable class name and commentable id.
  scope :find_comments_for_commentable, lambda { |commentable_str, commentable_id|
    where(:commentable_type => commentable_str.to_s, :commentable_id => commentable_id).order('created_at DESC')
  }

  # Helper class method to look up a commentable object
  # given the commentable class name and id
  def self.find_commentable(commentable_str, commentable_id)
    commentable_str.constantize.find(commentable_id)
  end

  # author로 view에서 조회하는게 맞는 것 같은데 gem 내부 동작에서 user로 지칭될 수 있으므로 author 가상 메소드 추가 함
  # belong_to :author로 변경시 validate, find_method모두 변경해야함
  def author
    self.user
  end
end
