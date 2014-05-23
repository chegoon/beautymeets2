ActiveAdmin.register User do

	index do
		column :id
		column :email
		column :username
		column :profile_type
		column :sign_in_count
		column :last_sign_in_at
		column :current_sign_in_at

		column "Transfer" do |user|
			if user.profile_type.to_s == 'Member'
				link_to 'go to beautystar', go_to_beautystar_admin_user_path(user) 
			elsif user.profile_type.to_s == 'Beautystar'
				link_to 'back to member', back_to_member_admin_user_path(user) 
			else
			end     
		end

		actions 

	end


	member_action :go_to_beautystar do
		user = User.find(params[:id])

		if user.present?
			user.remove_role :member
			user.remove_role :author, user.profile
			user.profile.destroy if !user.profile.nil?

			user.profile = Beautystar.create(fullname: user.name, slug: user.name)
			user.save

			user.add_role :beautystar
			user.add_role :author, user.profile
		end
		redirect_to admin_users_path
	end

	member_action :back_to_member do
		user = User.find(params[:id])
		
		if user.present?
			user.remove_role :beautystar
			user.remove_role :author, user.profile
			user.profile.destroy  if !user.profile.nil?

			user.profile = Member.create(slug: user.name)
			user.save
			
			user.add_role :member
			user.add_role :author, user.profile
		end
		redirect_to admin_users_path
	end

end
