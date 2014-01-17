ActiveAdmin.register Category do
  
	index do 
		column :id
		column :name
		column :view_count
		actions
	end
end