module API
	module V1
		class PostsController < API::V1::BaseController
			#before_filter :authenticate_user!
			before_filter :set_current_user
			
			def index

				offset = params[:offset] || 0
				limit = params[:limit] || 12

				@posts = Array.new
				menu = Category.where(name: params[:category], parent_id: Category.find_by_name("menu").id).first
				categories = menu ? Category.where(menu_id: menu.id) : nil
				#puts "params : #{params[:category]}"
				#puts "category : #{category}"
				# HOME 

				@connection = ActiveRecord::Base.establish_connection( 
					:adapter => "mysql2",
					:host => "localhost",
					:database => "beautymeets2_production",
					:username => "root",
					:password => "Reallplay0707"
				)

				if categories.nil? 
					sql = "SELECT posts.id as id, posts.post_type as post_type, posts.created_at as created_at
							FROM ( 
								SELECT 
									p.id, 'Post' as post_type, p.created_at as created_at
								    FROM posts p
								    WHERE p.published IS TRUE
								UNION
								SELECT
									t.id, 'Tutorial' as post_type, t.created_at as created_at
									FROM tutorials t
									WHERE t.published IS TRUE
								UNION
								SELECT
								    i.id, 'Item' as post_type, i.created_at as created_at
									FROM items i
								    WHERE i.published IS TRUE
								UNION
								SELECT
								    v.id, 'Video' as post_type, v.published_at as created_at
									FROM videos v, video_groups vg
								    WHERE v.published IS TRUE
								    AND v.video_group_id = vg.id
								    AND vg.published IS TRUE
							)
							AS posts ORDER BY posts.created_at DESC LIMIT " + limit.to_s  + " OFFSET " + offset.to_s
				else
					sql = "SELECT posts.id as id, posts.post_type as post_type, posts.created_at as created_at
							FROM ( 
								SELECT 
									p.id, 'Post' as post_type, p.created_at as created_at
								    FROM posts p
								    INNER JOIN categorizations 
								    	ON categorizations.categorizeable_id = p.id
								    	AND categorizations.categorizeable_type = 'Post' 
									INNER JOIN categories ON categories.id = categorizations.category_id
								    WHERE p.published IS TRUE
								    AND categories.id IN (" + categories.map(&:id).join(",") + ")
								UNION
								SELECT
									t.id, 'Tutorial' as post_type, t.created_at as created_at
									FROM tutorials t
								    INNER JOIN categorizations 
								    	ON categorizations.categorizeable_id = t.id
								    	AND categorizations.categorizeable_type = 'Tutorial' 
									INNER JOIN categories ON categories.id = categorizations.category_id
									WHERE t.published IS TRUE
								    AND categories.id IN (" + categories.map(&:id).join(",") + ")
								UNION
								SELECT
								    i.id, 'Item' as post_type, i.created_at as created_at
									FROM items i
								    INNER JOIN categorizations 
								    	ON categorizations.categorizeable_id = i.id
								    	AND categorizations.categorizeable_type = 'Item' 
									INNER JOIN categories ON categories.id = categorizations.category_id
								    WHERE i.published IS TRUE
								    AND categories.id IN (" + categories.map(&:id).join(",") + ")
								UNION
								SELECT
								    v.id, 'Video' as post_type, v.published_at as created_at
									FROM video_groups vg, videos v
								    INNER JOIN categorizations 
								    	ON categorizations.categorizeable_id = v.id
								    	AND categorizations.categorizeable_type = 'Video' 
									INNER JOIN categories ON categories.id = categorizations.category_id
								    WHERE v.published IS TRUE
								    AND v.video_group_id = vg.id
								    AND vg.published IS TRUE
								    AND categories.id IN (" + categories.map(&:id).join(",") + ")
							)
							AS posts ORDER BY posts.created_at DESC LIMIT " + limit.to_s  + " OFFSET " + offset.to_s

				end
				@posts = @connection.connection.execute(sql)

			end

			def show
				posttable = params[:postType].capitalize

				@post = posttable.classify.constantize.find(params[:id])

				@post.increment_view_count 
				impressionist(@post)
				@post.mark_as_read! :for => @user

				videoUrl = ""
				if posttable == "Item" 
					@related_posts = @post.tutorials.where(published: true)
				elsif posttable == "Tutorial"
					@related_posts = Tutorial.where(published: true).unread_by(@user).order("tutorials.view_count DESC").limit(10).sample(3)
					@post.author.id = 4
					@post.author.name = "BEAUTYMEETS Editor"
					#videoUrl = '<iframe src=' + @post.vimeo_url + '?title=0&amp;byline=0&amp;portrait=0&amp;color=5de0cf" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>'
				elsif posttable == "Video"
					@related_posts = Tutorial.where(published: true).unread_by(@user).order("tutorials.view_count DESC").limit(10).sample(3)
					#videoUrl = '<iframe width="560" height="315" src="' + @post.video_url + '" frameborder="0" allowfullscreen></iframe>'
				else
					@related_posts = Tutorial.where(published: true).unread_by(@user).order("tutorials.view_count DESC").limit(10).sample(3)
				end

			end

			def togglefavorite

				bookmark_type_id = BookmarkType.find_or_create_by_model(params[:postType]).id
				model_id = params[:id]
				
				@bookmark = Bookmark.find_bookmark(@user.id,bookmark_type_id,model_id)
				
				# We use a delete_all here because there is no other way in Rails to delete a row from a table without a PRIMARY KEY id
				if ( @bookmark )
					Bookmark.delete_all(["user_id = ? AND model_type_id = ? AND model_id = ?", @user.id, bookmark_type_id, model_id])
				else
					bookmark = Bookmark.create( :user_id => @user.id, :model_type_id => bookmark_type_id, :model_id => model_id)
					impressionist(bookmark)
				end
				
				render :status => 200, :json => { :success => true, :info => "Favorite created"}
			end

			private

			def set_current_user
				token = params[:authToken] 
				@user = User.find_by_authentication_token(token)
			end
		end
	end
end