class VideoGroup < ActiveRecord::Base
  
  resourcify
  include Authority::Abilities

  extend FriendlyId
  friendly_id :name, use:  [:slugged, :history]
  
  attr_accessible :name, :home_url, :thumb_url, :image, :youtube_id, :header_bg_url, :view_count, :published
  has_many :videos, dependent: :destroy

  mount_uploader :image, ImageUploader
  
  def increment_view_count(by = 1)
    self.view_count ||= 0
    self.view_count += by
    self.save
  end

  def self.update_group(id)
  	find(id).update_group
  end

  def update_group
  	puts "delayed_job called"
    video_group = self
    client = YouTubeIt::Client.new(:username => "hellobeauty@reallplay.com", :password =>  "reallplay0707",:dev_key => "AI39si4kYnOd5LRdnL4B9BIbBOLKPAG9y1O4Wh6a8cO8dvQ-Hsmv_fXPnmEYHu_ndnK0OijXoBtlNyAnzyJYChbuL7cnKsqjJA")

    if video_group.youtube_id.present? 
      yt_profile = client.profile(video_group.youtube_id) 
      yt_videos = client.videos_by(:user => video_group.youtube_id, :max_results => 50).videos #50개가 max

=begin
      if yu_videos.count = 50
        yu_videos = client.videos_by(:user => @video_group.youtube_id, :off_set => 49, :max_results => 50).videos
      end
=end
      # 영상이 채널인경우
      yt_videos.each do |yt_video|

        # 동일 URL이 있을경우 정보만 업데이트
        #video = @video_group.videos.find_or_create_by_video_url("http://www.youtube.com/embed/#{yt_video.video_id.split(":").last}")
        yt_vi_id = yt_video.video_id.split(":").last
        if !yt_vi_id.nil?
          video = video_group.videos.find_or_create_by_yt_vi_id(yt_vi_id)

          video.yt_vi_id = yt_vi_id
          # http를 붙일경우 4.0.3 iframe에서 영상 플레이 안됨 -> 됨
          video.video_url  = "http://www.youtube.com/embed/#{yt_vi_id}"
          #video.video_url  = "//www.youtube.com/embed/#{yt_vi_id}"
          video.title = yt_video.title
          #video.thumb_url = "http://img.youtube.com/vi/#{yt_video.video_id.split(":").last}/maxresdefault.jpg"
          video.thumb_url = "http://img.youtube.com/vi/#{yt_video.video_id.split(":").last}/0.jpg"
          video.description = yt_video.description
          video.duration = yt_video.duration
          video.favorite_count = yt_video.favorite_count
          video.published_at = yt_video.published_at.to_s

          if video.save
            video = video_group.videos.new
          end
        end



        puts "video info"
        puts yt_video.video_id.split(":").last #tag:youtube.com,2008:video:XI0UphKT8UA
        puts yt_video.view_count
        puts yt_video.description
        puts yt_video.duration
        puts yt_video.favorite_count
        puts yt_video.thumbnails #http://img.youtube.com/vi/<insert-youtube-video-id-here>/0.jpg
        puts yt_video.published_at

      end
      
      #puts yt_profile.inspect

      video_group.name = yt_profile.username
      video_group.home_url = "http://www.youtube.com/user/#{yt_profile.username}"
      video_group.thumb_url = yt_profile.avatar
      video_group.description = yt_profile.description
      video_group.videos_watched = yt_profile.videos_watched
      video_group.join_date = yt_profile.join_date.to_s
      video_group.subscribers = yt_profile.subscribers
      video_group.header_bg_url = ""
    end 
  end
end