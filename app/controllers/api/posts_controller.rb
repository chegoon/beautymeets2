module API
	class PostsController < ApplicationController
		after_filter :set_access_control_headers

		# This is used to allow the cross origin POST requests made by app.
		def set_access_control_headers
			headers['Access-Control-Allow-Origin'] = "*" #"http://localhost:3000"
			headers['Access-Control-Request-Method'] = "*" #%w{GET POST OPTIONS}.join(",")
		end
		
		def index
			#cards_per_page = 10
			#page(params[:page]).per_page(cards_per_page)
			@posts = Array.new
			category = Category.find_by_name(params[:category])
			#category = Category.where(name: params[:category]).first
			#puts "params : #{params[:category]}"
			#puts "category : #{category}"
			if category.nil? 
				Tutorial.where(published: true).last(5).each do |tutorial|
					pre_post = {
						postType: tutorial.class.name.underscore.humanize,
						id: tutorial.id, 
						title: tutorial.title, 
						category: tutorial.categories.map(&:name),
						author: { name: tutorial.author.try(:name) },
						url: tutorial_url(tutorial), 
						thumbUrl: request.protocol + request.host_with_port + tutorial.thumbnail.image_url,
						hits: tutorial.view_count,
						#bookmark_type 1~5:item, tutorial, video, beautyclass, post
						favorites: Bookmark.where(model_type_id: 2, model_id: tutorial.id).count,
						created_at: tutorial.created_at
					}
					@posts << pre_post
				end
				Post.where(published: true).last(5).each do |p|
					pre_post = { 
						postType: p.class.name.underscore.humanize,
						id: p.id, 
						title: p.title, 
						category: p.categories.map(&:name),
						author: { name: p.author.try(:name) },
						url: post_url(p), 
						thumbUrl: request.protocol + request.host_with_port + p.thumbnail.image_url,
						hits: p.view_count,
						#bookmark_type 1~5:item, tutorial, video, beautyclass, post
						favorites: Bookmark.where(model_type_id: 5, model_id: p.id).count,
						created_at: p.created_at
					}
					@posts << pre_post
				end
				Video.where(published: true).last(5).each do |video|
					pre_post = { 
						postType: video.class.name.underscore.humanize,
						id: video.id, 
						title: video.title, 
						category: video.categories.map(&:name),
						author: "BEAUTYMEETS", #{ name: video.author.try(:name) },
						url: video_url(video), 
						thumbUrl: video.thumb_url,
						hits: video.view_count,
						#bookmark_type 1~5:item, tutorial, video, beautyclass, post
						favorites: Bookmark.where(model_type_id: 3, model_id: video.id).count,
						created_at: video.created_at
					}
					@posts << pre_post
				end
				Item.last(5).each do |item|
					pre_post = { 
						postType: item.class.name.underscore.humanize,
						id: item.id, 
						title: item.name, 
						category: item.categories.map(&:name),
						author: "BEAUTYMEETS", #{ name: video.author.try(:name) },
						url: item_url(item), 
						thumbUrl: request.protocol + request.host_with_port + item.thumbnail.image_url,
						hits: item.view_count,
						#bookmark_type 1~5:item, tutorial, video, beautyclass, post
						favorites: Bookmark.where(model_type_id: 1, model_id: item.id).count,
						created_at: item.created_at
					}
					@posts << pre_post
				end
			else

				Tutorial.joins(:categories).where(published: true, categories: { id: category.id }).last(5).each do |tutorial|
					pre_post = { 
						postType: tutorial.class.name.underscore.humanize,
						id: tutorial.id, 
						title: tutorial.title, 
						category: tutorial.categories.map(&:name),
						author: { name: tutorial.author.try(:name) },
						url: tutorial_url(tutorial), 
						thumbUrl: request.protocol + request.host_with_port + tutorial.thumbnail.image_url,
						hits: tutorial.view_count,
						#bookmark_type 1~5:item, tutorial, video, beautyclass, post
						favorites: Bookmark.where(model_type_id: 2, model_id: tutorial.id).count,
						created_at: tutorial.created_at
					}
					@posts << pre_post
				end
				Post.joins(:categories).where(published: true, categories: { id: category.id }).last(5).each do |p|
					pre_post = { 
						postType: p.class.name.underscore.humanize,
						id: p.id, 
						title: p.title, 
						category: p.categories.map(&:name),
						author: { name: p.author.try(:name) },
						url: post_url(p), 
						thumbUrl: request.protocol + request.host_with_port + p.thumbnail.image_url,
						hits: p.view_count,
						#bookmark_type 1~5:item, tutorial, video, beautyclass, post
						favorites: Bookmark.where(model_type_id: 5, model_id: p.id).count,
						created_at: p.created_at
					}
					@posts << pre_post
				end
				Video.joins(:categories).where(published: true, categories: { id: category.id }).last(5).each do |video|
					pre_post = { 
						postType: video.class.name.underscore.humanize,
						id: video.id, 
						title: video.title, 
						category: video.categories.map(&:name),
						author: "BEAUTYMEETS", #{ name: video.author.try(:name) },
						url: video_url(video), 
						thumbUrl: video.thumb_url,
						hits: video.view_count,
						#bookmark_type 1~5:item, tutorial, video, beautyclass, post
						favorites: Bookmark.where(model_type_id: 3, model_id: video.id).count,
						created_at: video.created_at
					}
					@posts << pre_post
				end
				Item.joins(:categories).where(categories: { id: category.id }).last(5).each do |item|
					pre_post = { 
						postType: item.class.name.underscore.humanize,
						id: item.id, 
						title: item.name, 
						category: item.categories.map(&:name),
						author: "BEAUTYMEETS", #{ name: video.author.try(:name) },
						url: item_url(item), 
						thumbUrl: request.protocol + request.host_with_port + item.thumbnail.image_url,
						hits: item.view_count,
						#bookmark_type 1~5:item, tutorial, video, beautyclass, post
						favorites: Bookmark.where(model_type_id: 1, model_id: item.id).count,
						created_at: item.created_at
					}
					@posts << pre_post
				end
			end
			render json: @posts.sort_by{|e| e[:created_at]}.reverse
		end
		def show
			posttable = params[:postType]
			@post = posttable.constantize.find(params[:id])
			if posttable == "Item" || posttable == "Tutorial"
				@post.author.name = "BEAUTYMEETS"
			end

=begin
			@post << {
				postType: posttable,
				id: post.id, 
				title: post.title,
				author: {
					name: post.author.name 
				},
				category: post.categories.map(&:name),
				description: post.description,
				hits: post.view_count,
				favorites: ,
				images: [ post.pictures.map(&:image_url)
				],
				tags: [ post.tags.map(&:name)
				],
				comments: [
					author: {
						name: 
					}
				]
			}
=end			
			#render json: @post
		end
	end
end

=begin

		$scope.post = {
			title: "화장품 브랜드의 새로운 모델들",
			author: {
				name: "BEAUTYMEETS"
			},
			category: "Etc",
			description: "올가을 새롭게 바뀐 화장품 브랜드의 모델은 누구? 1.‪미샤‬ X ‪손예진‬ 2.‪‎바비브라운‬ X ‪박지윤‬ 3.‪바닐라코‬ X ‪‎송지효‬ ",
			hits: 1000,
			favorites: 200,
			images: [
				"http://beautymeets.com/uploads/picture/image/1290/1408580540_750439.jpg",
				"http://beautymeets.com/uploads/picture/image/1286/20140826000511_0_99_20140826100019.jpg",
				"http://beautymeets.com/uploads/picture/image/1287/2014082417231580_1_rstarsge.jpg"
			],
			tags: [{
				name: "여름 메이크업",
			},{
				name: "브론즈 메이크업",
			}],
			comments: [{
				author: {
					name: "러블리추"
				},
				body: "우와 정말 이쁘다",
				createdAt: "1 day ago"
			}, {
				author: {
					name: "러블리추"
				},
				body: "우와 정말 이쁘다",
				createdAt: "1 day ago"
			}, {
				author: {
					name: "러블리추"
				},
				body: "우와 정말 이쁘다",
				createdAt: "1 day ago"
			}]
		};
	

			title: '태닝피부에 예쁜 브론즈메이크업',
			category: 'Eye Makeup',
			author: {
				name: "BEAUTYMEETS"
			},
			url: 'tutorial.html',
			thumbUrl: 'http://beautymeets.com/uploads/picture/image/1187/thumb2_square.jpg',
			hits: 23000,
			favorites: 3000
	
=end