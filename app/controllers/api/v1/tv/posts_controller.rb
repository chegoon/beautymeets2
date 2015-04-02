module API
	module V1
		module Tv
			class PostsController < API::V1::BaseController
				#before_filter :authenticate_user!
				
				def index

					if params[:offset].present? && !(params[:offset] == "")
						offset = params[:offset]
					else
						offset = 0
					end
					limit = params[:limit] || 12

=begin
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
						#:database => "beautymeets2_development",
						:username => "root",
						#:password => "bd0516"
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
=end
					@posts = Tutorial.order("created_at DESC").offset(offset).limit(limit)
				end

				def show
					@post = Tutorial.find(params[:id])
=begin
					posttable = params[:postType].capitalize

					@post = posttable.classify.constantize.find(params[:id])

					
					if params[:offset].present? && !(params[:offset] == "")
						offset = params[:offset]
					else
						offset = 0
					end
					limit = params[:limit] || 12

					@post.increment_view_count 
					impressionist(@post)
					@post.mark_as_read! :for => @user

					videoUrl = ""
					if posttable == "Item" 

						@connection = ActiveRecord::Base.establish_connection( 
							:adapter => "mysql2",
							:host => "localhost",
							:database => "beautymeets2_production",
							#:database => "beautymeets2_development",
							:username => "root",
							#:password => "bd0516"
							:password => "Reallplay0707"
						)

						
						#@related_posts = @post.tutorials.where(published: true)
						#puts "#{@related_posts}"

						@related_posts = Array.new
						sql = "SELECT posts.id as id, posts.post_type as post_type, posts.created_at as created_at
								FROM ( 
									SELECT
										t.id, 'Tutorial' as post_type, t.created_at as created_at
										FROM tutorials t, itemizations it
										WHERE t.published IS TRUE
										AND t.id = it.itemizable_id
										AND it.itemizable_type = 'Tutorial'
										AND it.item_id = " + @post.id.to_s + "
									UNION
									SELECT
									    v.id, 'Video' as post_type, v.created_at as created_at
										FROM videos v, video_groups vg, itemizations it
									    WHERE v.published IS TRUE
									    AND v.video_group_id = vg.id
									    AND vg.published IS TRUE
										AND v.id = it.itemizable_id
										AND it.itemizable_type = 'Video'
										AND it.item_id = " + @post.id.to_s + "
								)
								AS posts ORDER BY posts.created_at DESC LIMIT " + limit.to_s  + " OFFSET " + offset.to_s

						@related_posts = @connection.connection.execute(sql)

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
=end
				end


			end
		end
	end
end