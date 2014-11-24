module API
	module V1
		class NoticesController < API::BaseController #InheritedResources::Base

			#authorize_actions_for Notice, except: [:index, :show]
			before_filter :set_current_user

			def index
				@notices = Notice.where("published = true AND id <> 2").order("created_at DESC")
			end

			def show

				@notice = Notice.find(params[:id])
				@notice.increment_view_count 

				if @notice.id == 2 

					@commentable = @notice
					comments_per_page = 7
					if params[:page] && (params[:page] != '')
						@comment_page_index = params[:page]
					else
						#@comment_page_index = @commentable.comment_threads.order("lft ASC").paginate(:page => params[:page], :per_page => comments_per_page).total_pages
						total_results = @commentable.comments.count
						@comment_page_index = total_results / comments_per_page + (total_results % comments_per_page == 0 ? 0 : 1)
		    
					end
					@comments = @commentable.comment_threads.order("lft ASC")#.page(@comment_page_index).per_page(comments_per_page)
				end



			end


			private

			def set_current_user
				token = params[:authToken] 
				@user = User.find_by_authentication_token(token)
			end
		end
	end
end