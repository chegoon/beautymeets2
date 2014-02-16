class BasicAuthorizer < ApplicationAuthorizer
	def self.creatable_by?(user)
		return true
	end

	def readable_by?(user)
		return true
	end

  def updatable_by?(user)
    (resource.author.id == user.id) ||  (user.has_role? :admin)
  end

  def deletable_by?(user)
    (resource.author.id == user.id) || (user.has_role? :admin)
  end
end