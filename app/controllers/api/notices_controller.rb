module API
	class NoticesController < API::BaseController #InheritedResources::Base

		#authorize_actions_for Notice, except: [:index, :show]

		def index

			@notices = Notice.where("published = true AND id <> 2").order("created_at DESC")
		end

		def show

			@notice = Notice.find(params[:id])

		end
	end
end