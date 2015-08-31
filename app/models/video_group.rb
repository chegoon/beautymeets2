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


  def self.update_groups
    vgs = VideoGroup.where(published: true).all
    vgs.each do |vg|
      #vg.update_group
      yt_ch = Yt::Channel.new id: vg.ch_id
      update_channel(vg, yt_ch)
    end
    
  end

  def update_channel(ch, yt_ch)
    puts "update_channel is called id: #{ch.id} ch_id: #{ch.ch_id} ch_title: #{ch.title}"

    ch.update(name: yt_ch.title, thumb_url: yt_ch.thumbnail_url, video_count: yt_ch.video_count, view_count: yt_ch.view_count)


    yt_videos = yt_ch.videos
    if yt_videos
      yt_videos.each do |yt_v|
        video = ch.videos.find_or_create_by(yt_vi_id: yt_v.id)              
        video.update(title: yt_v.title, description: yt_v.description, published_at: yt_v.published_at, thumb_url: yt_v.thumbnail_url, view_count: yt_v.view_count)
        
      end
    end           
  end

  def update_group
    video_group = self
    client = YouTubeIt::Client.new(:username => "hellobeauty@reallplay.com", :password =>  "reallplay0707",:dev_key => "AI39si4kYnOd5LRdnL4B9BIbBOLKPAG9y1O4Wh6a8cO8dvQ-Hsmv_fXPnmEYHu_ndnK0OijXoBtlNyAnzyJYChbuL7cnKsqjJA")

    if video_group.youtube_id.present? 
      yt_profile = client.profile(video_group.youtube_id) 
      yt_videos = client.videos_by(:user => video_group.youtube_id, :max_results => 50).videos #50개가 max


      # 영상이 채널인경우
      yt_videos.each do |yt_video|

        # 동일 URL이 있을경우 정보만 업데이트
        #video = @video_group.videos.find_or_create_by_video_url("http://www.youtube.com/embed/#{yt_video.video_id.split(":").last}")
        puts "youtube video id: #{yt_video.video_id}"
        yt_vi_id = yt_video.video_id.split(":").last
        if !yt_vi_id.nil?
          video = video_group.videos.find_or_create_by_yt_vi_id(yt_vi_id)

          video.yt_vi_id = yt_vi_id
          # http를 붙일경우 4.0.3 iframe에서 영상 플레이 안됨 -> 됨
          video.video_url  = "http://www.youtube.com/embed/#{yt_vi_id}"
          video.title = yt_video.title
          video.thumb_url = "http://img.youtube.com/vi/#{yt_video.video_id.split(":").last}/0.jpg"
          video.description = yt_video.description
          video.duration = yt_video.duration
          video.favorite_count = yt_video.favorite_count
          video.published_at = yt_video.published_at.to_s

          if video.save
            #video = video_group.videos.new
          end
        end
      end
      
      #puts yt_profile.inspect

      # controller에서 video_group.save를 하기 때문에 아래는 assign만 해주고
      # save는 생략, 실제로 입력시 두번 data create 이 발
      video_group.name = yt_profile.username
      video_group.home_url = "http://www.youtube.com/user/#{yt_profile.username}"
      video_group.thumb_url = yt_profile.avatar
      video_group.description = yt_profile.description
      video_group.videos_watched = yt_profile.videos_watched
      video_group.join_date = yt_profile.join_date.to_s
      video_group.subscribers = yt_profile.subscribers
      video_group.header_bg_url = ""

      puts "yt_profile.username : #{yt_profile.username}"
      puts "yt_profile.avatar : #{yt_profile.avatar}"
      puts "yt_profile.description : #{yt_profile.description}"
      puts "yt_profile.videos_watched : #{yt_profile.videos_watched}"
      puts "yt_profile.subscribers : #{yt_profile.subscribers}"
      puts "yt_profile.join_date : #{yt_profile.join_date}"
    end 
  end
end