ActiveAdmin.register Impression do
	index do 
		column :id
		column :impressionable_type
		column :impressionable
		#column :action_name
		column :user_id
		column :referrer
		column :created_at
		#actions
	end
end
