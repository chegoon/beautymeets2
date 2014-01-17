ActiveAdmin.register Video do

	index do 
		column :id
=begin		
		column "thumb_url"  do |thumb|
			image_tag(thumb.thumb_url, :style => "height:100px;")
		end
=end		
		column :title

		column :view_count
		column "Review", :published
		column :published_at
		column "Action" do |v|
			link_to 'video review', video_path(v)
		end
		default_actions
	end

    show do |v|
      attributes_table do
        row :title
        row :image do
          image_tag(v.thumb_url)
        end
      end

    end

=begin          
    show do |video|

      attributes_table do
        row :title

        row :thumb_url do
          image_tag("http:#{video.thumb_url}")
        end

      end
      active_admin_comments

    end
=end
end
