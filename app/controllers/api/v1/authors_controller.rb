module API
	module V1
		class AuthorsController < API::V1::BaseController
			before_filter :set_current_user
			
			def index

				offset = params[:offset] || 0
				limit = params[:limit] || 12

				@authors = Array.new
				@connection = ActiveRecord::Base.establish_connection( 
					:adapter => "mysql2",
					:host => "localhost",
					#:database => "beautymeets2_production",
					:database => "beautymeets2_development",
					:username => "root",
					#:password => "Reallplay0707"
					:password => "bd0516"
				)

				sql = "SELECT authors.id as id, authors.author_type as author_type, authors.created_at as created_at
						FROM ( 
							SELECT 
								vg.id, 'VideoGroup' as author_type, vg.created_at as created_at
							    FROM video_groups vg
							    WHERE vg.published IS TRUE
							UNION
							SELECT
								b.id, 'Brand' as author_type, b.created_at as created_at
								FROM brands b
								WHERE t.published IS TRUE
							UNION
							SELECT
							    u.id, 'User' as author_type, u.created_at as created_at
								FROM users u
								WHERE id = 4
						)
						AS authors ORDER BY authors.created_at DESC LIMIT " + limit.to_s  + " OFFSET " + offset.to_s

				@authors = @connection.connection.execute(sql)
			end

			def show
				offset = params[:offset] || 0
				limit = params[:limit] || 12

				authorable = params[:postType] ? params[:postType].capitalize : params[:author_type]

				if authorable == "Tutorial"
					#@author = authorable.classify.constantize.find(params[:id])
					#@author = User.find(params[:id])
					@author = User.find(4)
					@posts = Tutorial.where(published: true).order("created_at DESC").offset(offset).limit(limit)
					@total_posts_count = Tutorial.where(published: true).count
				elsif authorable == "Video"
					@author = VideoGroup.find(params[:id])
					@posts = @author.videos.where(published: true).order("created_at DESC").offset(offset).limit(limit)
					@total_posts_count = @author.videos.where(published: true).count
				elsif authorable == "Item"
					@author = Brand.find(params[:id])
					@posts = @author.items.order("created_at DESC").offset(offset).limit(limit)
					@total_posts_count = @author.items.where(published: true).count
				else #post
					#@author = User.find(params[:id])
					@author = User.find(4)
					@posts = Post.where(published: true).order("created_at DESC").offset(offset).limit(limit)
					@total_posts_count = Post.where(published: true).count
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