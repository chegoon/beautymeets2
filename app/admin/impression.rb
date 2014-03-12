ActiveAdmin.register Impression do
	index do 
		column :id
		column :impressionable_type
		column :impressionable_id
		column :action_name
		column :user_id
		column :referrer
		actions
	end
end
