class Checkout < ActiveRecord::Base
	after_create :set_default_status

  belongs_to :beautyclass
  belongs_to :user
  belongs_to :status, class_name: "CheckoutStatus", foreign_key: "checkout_status_id"
  
  attr_accessible :checkout_status, :description, :user, :buyer_name, :buyer_tel, :checkout_status_id, :request_note

  def set_default_status
  	self.status = CheckoutStatus.find_by_name("Register")
    self.save
  end

  def status_name
  	self.status.name
  end
end
