require File.expand_path('lib/uboost-client')

subdomain        = ENV['UBOOST_SUBDOMAIN']
api_credentials  = { :username => ENV['UBOOST_USERNAME'], :password => ENV['UBOOST_PASSWORD'] }

client = UboostClient::Client.new(:subdomain => subdomain, :api_credentials => api_credentials)

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
# puts client.widgets.profile(921679373)
# puts client.widgets.my_badges(921679373)
# puts client.widgets.ubar(921679373)
