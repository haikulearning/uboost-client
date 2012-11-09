require File.expand_path('lib/uboost-client')
require "pp"

subdomain        = ENV['UBOOST_SUBDOMAIN']
api_credentials  = { :username => ENV['UBOOST_USERNAME'], :password => ENV['UBOOST_PASSWORD'] }
session = Hash.new 

client = UboostClient::Client.new(:subdomain => subdomain, :api_credentials => api_credentials, :debug => false)

# puts client.account.create({ "user_name" => "test_user_2" })
# puts client.account.select(921679373)
# puts client.account.delete(921679358)
# puts client.account.update(921679358, {:first_name => 'custom name'})
# puts client.account.find(:user_name => 'isaacnewtonx')
# puts client.account.find(:external_id => '3253466')
# puts client.account.token(921679358)
# puts client.points.point_transactions_for_account(921679358)

# puts client.account.points_transactions(921679358)
# puts client.points.add_points_to_account(921679359, 30, {:description => 'whatps'})

# puts client.badges.award(921679373, 467)
# puts client.badges.unaward(921679373, 467)

# puts client.widgets.profile(:account_id => 921679373)
# puts client.widgets(:session => session).profile(:account_id => 921679373)

# puts client.widgets.my_badges(:account_id => 921679373)
# puts client.widgets(:session => session).my_badges(:account_id => 921679373)

# puts client.widgets.ubar(:account_id => 921679373)

# puts client.widgets.list_of_leaderboards(:account_id => 921679373)
# puts client.widgets(:session => session).list_of_leaderboards(:account_id => 921679373)

# puts client.widgets.leaderboard(:account_id => 921679373, :leaderboard_id => 226)
# puts client.widgets(:session => session).leaderboard(:account_id => 921679373, :leaderboard_id => 226)

# puts client.widgets.badge_categories(:account_id => 921679373)

# puts client.widgets.badges_for_category(:account_id => 921679373, :badge_category_id => 31)

# puts client.widgets.unearned_badges(:account_id => 921679373, :badge_category_id => 31)