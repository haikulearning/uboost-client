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
  {:username => 'api_username', password => 'api_password'})

# Examples

client.account.create({ "user_name" => "test_user_2" })

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
```