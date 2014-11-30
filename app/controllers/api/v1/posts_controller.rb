module API
	module V1
		class PostsController < API::BaseController
			#before_filter :authenticate_user!
			before_filter :set_current_user
			
			def index

				offset = params[:offset] ? (params[:offset].to_f / 4).to_i : 0
				limit = params[:limit] || 3
				#@comments = @commentable.comment_threads.order("lft ASC").offset(offset).limit(limit)

				#cards_per_page = 10
				#page(params[:page]).per_page(cards_per_page)
				@posts = Array.new
				menu = Category.where(name: params[:category], parent_id: Category.find_by_name("menu")).first
				categories = menu ? Category.where(menu_id: menu.id) : nil
				#puts "params : #{params[:category]}"
				#puts "category : #{category}"
				# HOME 
				if categories.nil? 
					Tutorial.where(published: true).order("created_at DESC").offset(offset).limit(limit).each do |tutorial|
						pre_post = {
							postType: tutorial.class.name.underscore.humanize,
							isVideoPlayable: true,
							id: tutorial.id, 
							title: tutorial.try(:title), 
							category: tutorial.categories.map(&:name),
							author: { name: tutorial.author.try(:name) },
							url: tutorial_url(tutorial), 
							thumbUrl: tutorial.thumbnail ? (request.protocol + request.host_with_port + tutorial.thumbnail.image_url) : "",
							hits: tutorial.view_count,
							#bookmark_type 1~5:item, tutorial, video, beautyclass, post
							comments_count: tutorial.comments.count,
							favorites: Bookmark.where(model_type_id: 2, model_id: tutorial.id).count,
							favorited: Bookmark.where(model_type_id: 2, model_id: tutorial.id, user_id: @user.id).count > 0 ? 1 : nil,
							created_at: tutorial.created_at, 
							unread: tutorial.unread?(@user)
						}
						@posts << pre_post
					end
					Post.where(published: true).order("created_at DESC").offset(offset).limit(limit).each do |p|
						pre_post = { 
							postType: p.class.name.underscore.humanize,
							isVideoPlayable: false,
							id: p.id, 
							title: p.title, 
							category: p.categories.map(&:name),
							author: { name: p.author.try(:name) },
							url: post_url(p), 
							thumbUrl: request.protocol + request.host_with_port + p.thumbnail.image_url,
							hits: p.view_count,
							#bookmark_type 1~5:item, tutorial, video, beautyclass, post
							comments_count: p.comments.count,
							favorites: Bookmark.where(model_type_id: 5, model_id: p.id).count,
							favorited: Bookmark.where(model_type_id: 5, model_id: p.id, user_id: @user.id).count > 0 ? 1 : nil,
							created_at: p.created_at, 
							unread: p.unread?(@user)
						}
						@posts << pre_post
					end
					Video.where(published: true).order("created_at DESC").offset(offset).limit(limit).each do |video|
						pre_post = { 
							postType: video.class.name.underscore.humanize,
							isVideoPlayable: true,
							id: video.id, 
							title: video.title, 
							category: video.categories.map(&:name),
							author: { name: video.author.try(:name) },
							url: video_url(video), 
							thumbUrl: video.thumb_url,
							hits: video.view_count,
							#bookmark_type 1~5:item, tutorial, video, beautyclass, post
							comments_count: video.comments.count,
							favorites: Bookmark.where(model_type_id: 3, model_id: video.id).count,
							favorited: Bookmark.where(model_type_id: 3, model_id: video.id, user_id: @user.id).count > 0  ? 1 : nil,
							created_at: video.created_at, 
							unread: video.unread?(@user)
						}
						@posts << pre_post
					end
					Item.order("created_at DESC").offset(offset).limit(limit).each do |item|
						pre_post = { 
							postType: item.class.name.underscore.humanize,
							isVideoPlayable: false,
							id: item.id, 
							title: item.name, 
							category: item.categories.map(&:name),
							author:  { name: "#{item.tutorials.order("created_at DESC").first.try(:title)}" },
							url: item_url(item), 
							thumbUrl: request.protocol + request.host_with_port + item.thumbnail.image_url,
							hits: item.view_count,
							#bookmark_type 1~5:item, tutorial, video, beautyclass, post
							comments_count: item.comments.count,
							favorites: Bookmark.where(model_type_id: 1, model_id: item.id).count,
							favorited: Bookmark.where(model_type_id: 1, model_id: item.id, user_id: @user.id).count > 0  ? 1 : nil,
							created_at: item.created_at, 
							unread: item.unread?(@user)
						}
						@posts << pre_post
					end
				# category selected.				
				else
					#Tutorial.joins(:categories).where(published: true, categories: { menu_id: category.id }).order("created_at DESC").limit(5).each do |tutorial|
					Tutorial.joins(:categories).where("tutorials.published is true AND categories.id IN (?)", categories.map(&:id)).order("created_at DESC").offset(offset).limit(limit).each do |tutorial|
						pre_post = { 
							postType: tutorial.class.name.underscore.humanize,
							isVideoPlayable: true,
							id: tutorial.id, 
							title: tutorial.title, 
							category: tutorial.categories.map(&:name),
							author: { name: tutorial.author.try(:name) },
							url: tutorial_url(tutorial), 
							thumbUrl: request.protocol + request.host_with_port + tutorial.thumbnail.image_url,
							hits: tutorial.view_count,
							#bookmark_type 1~5:item, tutorial, video, beautyclass, post
							comments_count: tutorial.comments.count,
							favorites: Bookmark.where(model_type_id: 2, model_id: tutorial.id).count,
							favorited: Bookmark.where(model_type_id: 2, model_id: tutorial.id, user_id: @user.id).count > 0  ? 1 : nil,
							created_at: tutorial.created_at, 
							unread: tutorial.unread?(@user)
						}
						@posts << pre_post
					end
					#Post.joins(:categories).where(published: true, categories: { menu_id: category.id }).order("created_at DESC").limit(5).each do |p|
					Post.joins(:categories).where("posts.published is true AND categories.id IN (?)", categories.map(&:id)).order("created_at DESC").offset(offset).limit(limit).each do |p|
						pre_post = { 
							postType: p.class.name.underscore.humanize,
							isVideoPlayable: false,
							id: p.id, 
							title: p.title, 
							category: p.categories.map(&:name),
							author: { name: p.author.try(:name) },
							url: post_url(p), 
							thumbUrl: request.protocol + request.host_with_port + p.thumbnail.image_url,
							hits: p.view_count,
							#bookmark_type 1~5:item, tutorial, video, beautyclass, post
							comments_count: p.comments.count,
							favorites: Bookmark.where(model_type_id: 5, model_id: p.id).count,
							favorited: Bookmark.where(model_type_id: 5, model_id: p.id, user_id: @user.id).count > 0  ? 1 : nil,
							created_at: p.created_at, 
							unread: p.unread?(@user)
						}
						@posts << pre_post
					end
					#Video.joins(:categories).where(published: true, categories: { menu_id: category.id }).order("created_at DESC").limit(5).each do |video|
					Video.joins(:categories).where("videos.published is true AND categories.id IN (?)", categories.map(&:id)).order("created_at DESC").offset(offset).limit(limit).each do |video|
						pre_post = { 
							postType: video.class.name.underscore.humanize,
							isVideoPlayable: true,
							id: video.id, 
							title: video.title, 
							category: video.categories.map(&:name),
							author: "BEAUTYMEETS", #{ name: video.author.try(:name) },
							url: video_url(video), 
							thumbUrl: video.thumb_url,
							hits: video.view_count,
							#bookmark_type 1~5:item, tutorial, video, beautyclass, post
							comments_count: video.comments.count,
							favorites: Bookmark.where(model_type_id: 3, model_id: video.id).count,
							favorited: Bookmark.where(model_type_id: 3, model_id: video.id, user_id: @user.id).count > 0  ? 1 : nil,
							created_at: video.created_at, 
							unread: video.unread?(@user)
						}
						@posts << pre_post
					end
					#Item.joins(:categories).where(categories: { menu_id: category.id }).order("created_at DESC").limit(5).each do |item|
					Item.joins(:categories).where("categories.id IN (?)", categories.map(&:id)).order("created_at DESC").offset(offset).limit(limit).each do |item|	
						pre_post = { 
							postType: item.class.name.underscore.humanize,
							isVideoPlayable: false,
							id: item.id, 
							title: item.name, 
							category: item.categories.map(&:name),
							author: { name: "#{item.tutorials.order("created_at DESC").first.try(:title)}" },
							url: item_url(item), 
							thumbUrl: request.protocol + request.host_with_port + item.thumbnail.image_url,
							hits: item.view_count,
							#bookmark_type 1~5:item, tutorial, video, beautyclass, post
							comments_count: item.comments.count,
							favorites: Bookmark.where(model_type_id: 1, model_id: item.id).count,
							favorited: Bookmark.where(model_type_id: 1, model_id: item.id, user_id: @user.id).count > 0  ? 1 : nil,
							created_at: item.created_at, 
							unread: item.unread?(@user)
						}
						@posts << pre_post
					end
				end
				render json: @posts.sort_by{|e| e[:created_at]}.reverse
			end

			def show
				posttable = params[:postType]

				@post = posttable.classify.constantize.find(params[:id])

				@post.increment_view_count 
				impressionist(@post)
				@post.mark_as_read! :for => @user

				videoUrl = ""
				if posttable == "Item" 
					@related_posts = @post.tutorials
				elsif posttable == "Tutorial"
					@related_posts = Tutorial.unread_by(@user).where("id != ? AND published IS TRUE", @post.id).order("view_count DESC").limit(10).sample(3)
					@post.author.name = "BEAUTYMEETS"
					#videoUrl = '<iframe src=' + @post.vimeo_url + '?title=0&amp;byline=0&amp;portrait=0&amp;color=5de0cf" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>'
				elsif posttable == "Video"
					@related_posts = Tutorial.unread_by(@user).where(published: true).order("view_count DESC").limit(10).sample(3)
					#videoUrl = '<iframe width="560" height="315" src="' + @post.video_url + '" frameborder="0" allowfullscreen></iframe>'
				else
					@related_posts = Tutorial.unread_by(@user).where("id != ? AND published IS TRUE", @post.id).order("view_count DESC").limit(10).sample(3)
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