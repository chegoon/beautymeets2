atom_feed do |feed|
	feed.title "BEAUTYMEETS Hot Reads"
	
	@best_tutorials.each do |tutorial|
		feed.entry tutorial do |entry|
			entry.id tutorial.slug
      		entry.link tutorial_url(tutorial)
      		entry.img src: full_url(tutorial.thumbnail.image_url)
			entry.title tutorial.title
			#entry.content tutorial.description, :type => 'html'
			entry.content sanitize("<iframe width='420' height='315' src='#{tutorial.vimeo_url}?title=0&byline=0&portrait=1' frameborder='0' allowfullscreen></iframe>#{tutorial.description}"), :type => "html"
			entry.summary truncate(tutorial.description, 100)
		end
	end
	@latest_tutorials.each do |tutorial|
		feed.entry tutorial do |entry|
			entry.id tutorial.slug
      		entry.link tutorial_url(tutorial)
      		entry.img src: full_url(tutorial.thumbnail.image_url)
			entry.title tutorial.title
			entry.content sanitize("<iframe width='420' height='315' src='#{tutorial.vimeo_url}?title=0&byline=0&portrait=1' frameborder='0' allowfullscreen></iframe>#{tutorial.description}"), :type => "html"
			entry.summary truncate(tutorial.description, 100)
		end
	end
	@latest_posts.each do |post|
		feed.entry post do |entry|
			entry.id post.slug
      		entry.link post_url(post)
      		entry.img src: full_url(post.thumbnail.image_url)
			entry.title post.title
			entry.content post.description, :type => 'html'
			entry.summary truncate(post.description, 100)
		end
	end
end