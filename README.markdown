# uBoost Client API

This is the unofficial ruby client for uBoost API. It is a wrapper for the REST interface described at [https://github.com/chriskk/uBoost-API-v2](https://github.com/chriskk/uBoost-API-v2)

## Installing

```bash
gem install 'uboost-client'
```

## API

```ruby
require 'uboost-client'

client = UboostClient::Client.new(:subdomain => 'test_subdomain', :api_credentials => 
  {:username => 'api_username', :password => 'api_password'})

# Examples
#
# All commands return a OpenStruct. Its structure correlates to the 
# JSON that is returned from uBoost API.

response = client.account.create({ "user_name" => "test_user_2" })
  =>
    <OpenStruct student={"id"=>921679358, 
      "external_id"=>nil, 
      "catalog_id"=>109,   
      "points"=>0, ...}
    
response.student[:points] 
  => 0
  
or if there is any error:

response.status
  => 422
response.message 
  => "Widgets API requires a student account"

client.account.select(921679358)

client.account.delete(921679358)

client.account.update(921679358, {:first_name => 'custom name'})

client.account.find(:user_name => 'isaacnewtonx')

client.account.find(:external_id => '3253466')

client.account.token(921679358)

client.points.point_transactions_for_account(921679358)

client.account.points_transactions(921679358)

client.points.add_points_to_account(921679359, 30, {:description => 'a description'})

client.badges.award(921679359, 1)

client.badges.unaward(921679359, 1)

client.widgets.profile(921679358)

client.widgets.my_badges(921679358)

client.widgets.ubar(921679358)

```