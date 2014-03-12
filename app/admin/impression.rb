ActiveAdmin.register Impression do
	index do 
		column :id
		column :impressionable_type
		column :impressionable_id
		column :action_type
		column :user
		column :refferer
		actions
	end
end
