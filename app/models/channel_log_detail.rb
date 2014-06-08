class ChannelLogDetail < ActiveRecord::Base
  belongs_to :channel_log
  attr_accessible :collected_at, :comment_count, :like_count, :share_count, :view_count
end
