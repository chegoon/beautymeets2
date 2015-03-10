module API
	module V1
		class ReportsController < API::V1::BaseController
			before_filter :set_current_user
			

			# POST /suggests
			# POST /suggests.json
			def create
				params[:report] = {title: "test", description: "test body"}
				respond_to do |format|
					report_result = GlobalMailer.delay.report(@user, params[:report][:title], params[:report][:description])	
					if report_result
					#GlobalMailer.report(@user, "ttite", "des")	
						format.json { render json: "", status: :created }
					else
						format.json { render json: "", status: :unprocessable_entity }
					end
				end
			end

			private

			def set_current_user
				token = params[:authToken] 
				@user = User.find_by_authentication_token(token)
				if @user.nil?
					format.json { render json: "", status: :unprocessable_entity }
				end
			end
		end
	end
end
