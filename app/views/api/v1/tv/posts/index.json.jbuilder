json.tv_posts do
	json.array! @categories do |c|
		json.category c.name
		cats = Category.where(menu_id: c.id)

		sql = "SELECT posts.id as id, posts.post_type as post_type, posts.created_at as created_at
				FROM ( 
					SELECT 
						p.id, 'Post' as post_type, p.created_at as created_at
					    FROM posts p
					    INNER JOIN categorizations cz
					    	ON cz.categorizeable_id = p.id
					    	AND cz.categorizeable_type = 'Post' 
						INNER JOIN categories c ON c.id = cz.category_id
					    WHERE p.published IS TRUE
					    AND c.id IN (" + cats.map(&:id).join(",") + ")
					UNION
					SELECT
						t.id, 'Tutorial' as post_type, t.created_at as created_at
						FROM tutorials t
					    INNER JOIN categorizations cz
					    	ON cz.categorizeable_id = t.id
					    	AND cz.categorizeable_type = 'Tutorial' 
						INNER JOIN categories c ON c.id = cz.category_id
						WHERE t.published IS TRUE
					    AND c.id IN (" + cats.map(&:id).join(",") + ")
					UNION
					SELECT
					    i.id, 'Item' as post_type, i.created_at as created_at
						FROM items i
					    INNER JOIN categorizations cz
					    	ON cz.categorizeable_id = i.id
					    	AND cz.categorizeable_type = 'Item' 
						INNER JOIN categories c ON c.id = cz.category_id
					    WHERE i.published IS TRUE
					    AND c.id IN (" + cats.map(&:id).join(",") + ")
					UNION
					SELECT
					    v.id, 'Video' as post_type, v.published_at as created_at
						FROM video_groups vg, videos v
					    INNER JOIN categorizations cz
					    	ON cz.categorizeable_id = v.id
					    	AND cz.categorizeable_type = 'Video' 
						INNER JOIN categories c ON c.id = cz.category_id
					    WHERE v.published IS TRUE
					    AND v.video_group_id = vg.id
					    AND vg.published IS TRUE
					    AND c.id IN (" + cats.map(&:id).join(",") + ")
				)
				AS posts ORDER BY posts.created_at DESC LIMIT " + @limit.to_s  + " OFFSET " + @offset.to_s

		posts = Array.new
		posts = @connection.connection.execute(sql)


		json.posts do
			json.array! posts do |p|
				json.partial! 'api/v1/tv/posts/post', post: p[1].classify.constantize.find(p[0])
			end
		end
	end
end