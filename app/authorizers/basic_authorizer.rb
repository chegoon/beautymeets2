class BasicAuthorizer < ApplicationAuthorizer
	def self.creatable_by?(user)
		puts "BasicAuthorizer called, creatable_by"
		return true
	end

	def readable_by?(user)
		return true
	end

	def votable_by?(user)
		puts "BasicAuthorizer called, votable_by"
		return true
	end
	
	def updatable_by?(user)
		puts "BasicAuthorizer called, updatable_by"
		if resource.author.nil?
			if user.has_role? :admin 
				return true
			else
				return false
			end
		elsif resource.author.id == user.id
			return true
		elsif user.has_role? :admin
			return true
		else 
			return false
		end  
	end

	def deletable_by?(user)
		puts "BasicAuthorizer called, deletable_by"
		if resource.author.nil?
			if user.has_role? :admin 
				return true
			else
				return false
			end
		elsif resource.author.id == user.id
			return true
		elsif user.has_role? :admin
			return true
		else 
			return false
		end  
	end
end