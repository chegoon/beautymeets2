class BeautystarAuthorizer < ApplicationAuthorizer

	def self.creatable_by?(user)
		puts "BeautystarAuthorizer called, creatable_by "
		#puts user.has_role? :beautystar
		(user.has_role? :beautystar) || (user.has_role? :admin)
	end

	def readable_by?(user)
		puts "BeautystarAuthorizer called, readable_by "
		return true
	end

	def updatable_by?(user)
		puts "BeautystarAuthorizer called, updatable_by "
		#(resource.author.id == user.id) ||  (user.has_role? :admin)
		if resource.class.name == "Beautystar" 
			if resource.user.nil?
				if user.has_role? :admin 
					return true
				else
					return false
				end
			elsif resource.user.id == user.id
				return true
			elsif user.has_role? :admin
				return true
			else 
				return false
			end
		else
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

	def deletable_by?(user)
		puts "BeautystarAuthorizer called, deletable_by "
		#(resource.author.id == user.id) || (user.has_role? :admin)

		if resource.class.name == "Beautystar" 

			if resource.user.nil?
				if user.has_role? :admin 
					return true
				else
					return false
				end
			elsif resource.user.id == user.id
				return true
			elsif user.has_role? :admin
				return true
			else 
				return false
			end
		else
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
		
end