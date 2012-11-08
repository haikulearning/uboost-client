# uBoost Client API

This is the unofficial ruby client for uBoost API. It is a wrapper for the REST interface described at [https://github.com/uboost/uBoost-API-v2](https://github.com/uboost/uBoost-API-v2)

## Installing

```bash
gem install 'uboost-client'
```

## API

```ruby
require 'uboost-client'

client = UboostClient::Client.new(:subdomain => 'test_subdomain', 
                                  :debug => true, # Print debug info. Defaults to false
                                  :api_credentials => 
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
```

### Account

https://github.com/uboost/uBoost-API-v2#accounts-api

```ruby
client.account.create({ "user_name" => "test_user_2" })

client.account.select(921679358)

client.account.delete(921679358)

client.account.update(921679358, {:first_name => 'custom name'})

client.account.find(:user_name => 'isaacnewtonx')

client.account.find(:external_id => '3253466')

client.account.token(921679358)
```

### Points

https://github.com/uboost/uBoost-API-v2#points-api

```ruby
client.points.point_transactions_for_account(921679358)

client.account.points_transactions(921679358)

client.points.add_points_to_account(921679359, 30, {:description => 'a description'})
```

### Badges

https://github.com/uboost/uBoost-API-v2#badges-api

```ruby
client.badges.award(921679359, 1)

client.badges.unaward(921679359, 1)
```

### Widgets

https://github.com/uboost/uBoost-API-v2#widgets-api

Authentication for the Widgets API can be made by: sending in a student account's username and password, or have the gem automatically use SSO and cookies.

```ruby
# Use the student's username and password
response = client.account.select(921679358)
credentials = { credentials: { username: response.student["user_name"], password: response.student["password"]} }
client.widgets(credentials).profile
```

The widgets section can make use of a session store. Just pass a session object - something that quacks like a hash - and the first call it makes will cache the `_uboost_session_id` that the uBoost API returns, to `:uboost_session_id` in the session object.

```ruby
session = Hash.new # or a Ruby on Rails session, for example

# No caching
client.widgets.profile(:account_id => 921679373)
# Caching activated. It will cache the uboost sesion.
client.widgets(:session => session).profile(:account_id => 921679373)
# Caching activated. It will use the cached uboost sesion.
client.widgets(:session => session).profile(:account_id => 921679373)

client.widgets.my_badges(:account_id => 921679373)
client.widgets(:session => session).my_badges(:account_id => 921679373)

client.widgets.ubar(:account_id => 921679373)

client.widgets.list_of_leaderboards(:account_id => 921679373)
client.widgets(:session => session).list_of_leaderboards(:account_id => 921679373)

client.widgets.leaderboard(:account_id => 921679373, :leaderboard_id => 226)
client.widgets(:session => session).leaderboard(:account_id => 921679373, :leaderboard_id => 226)
```