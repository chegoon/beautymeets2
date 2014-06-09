# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
#set :environment, "development"
set :output, "log/cron_log.log"
#every 1.day, :at => '11:55 pm' do
every 2.minutes do
	runner "ChannelLog.update_log_details"
end
every 2.minutes do
#every 2.days, :at => '11:55 pm' do
	runner "VideoGroup.update_groups"
end