ActiveAdmin.register Checkout do


    form do |f|
      f.inputs "Checkout Detail" do
        f.input :status
        f.input :buyer_name
        f.input :buyer_tel
        f.input :description

      end

      f.actions
    end


  index do
    column :id
    column :beautyclass
    column :user
    column :status
    default_actions
    column :buyer_name
    column :buyer_tel
    column :created_at


  end
=begin
    member_action :confirmed do
      checkout = Checkout.find(params[:id])

	if checkout.present?
		checkout.payoff = true
		checkout.save!
	end
    	redirect_to admin_checkouts_path
    end

    member_action :cancel_payoff do
      checkout = Checkout.find(params[:id])

	if checkout.present?
		checkout.payoff = false
		checkout.save!
	end
    	redirect_to admin_checkouts_path
    end
=end

end
