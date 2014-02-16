class MemberAuthorizer < ApplicationAuthorizer
	def self.creatable_by?(user)
		(user.has_role? :member) || (user.has_role? :admin)
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