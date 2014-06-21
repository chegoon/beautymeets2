atom_feed do |feed|
	feed.title "BEAUTYMEETS Hot Reads"
	
	@best_tutorials.each do |tutorial|
		feed.entry tutorial do |entry|
			entry.id tutorial.slug
      		entry.link tutorial_url(tutorial)
			entry.title tutorial.title
			entry.content tutorial.description
		end
	end
	@latest_tutorials.each do |tutorial|
		feed.entry tutorial do |entry|
			entry.id tutorial.slug
      		entry.link tutorial_url(tutorial)
			entry.title tutorial.title
			entry.content tutorial.description
		end
	end
	@latest_posts.each do |post|
		feed.entry post do |entry|
			entry.id post.slug
      		entry.link post_url(post)
			entry.title post.title
			entry.content post.description
		end
	end
end