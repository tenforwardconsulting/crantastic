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

set :output, "/u/apps/crantastic/current/log/cron.log"
env :PATH, ENV['PATH'] # Else it can't find the bundle command

# jefferies_tube
every :hour do
  rake "db:backup:hourly"
end

every 20.minutes do
  rake 'crantastic:update_packages'
end

every "15 2,6,10,14,18,22 * * *" do
  rake "crantastic:update_taskviews"
end

# every :day, at: "7pm" do
#   rake "crantastic:tweet"
# end

every :sunday, at: "7pm" do
  rake "crantastic:create_weekly_digest"
end
