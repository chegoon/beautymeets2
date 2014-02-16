class Brand < ActiveRecord::Base
  resourcify
  include Authority::Abilities

  extend FriendlyId
  friendly_id :name, use: :slugged
  
  belongs_to :company
  attr_accessible :description, :name, :view_count, :image, :company_name, :picture_id
  
  has_many :pictures, as: :pictureable, dependent: :destroy
  belongs_to :thumbnail, class_name: "Picture", :foreign_key => "picture_id"
  

  has_many :items

  def increment_view_count(by = 1)
	  self.view_count ||= 0
	  self.view_count += by
	  self.save
	end

  def company_name
    #brand.name if brand
    company.try(:name)
  end
    
  def company_name=(name)
    self.company = Company.find_or_create_by_name(name) if name.present?
  end
end
