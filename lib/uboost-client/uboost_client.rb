require 'rubygems'
require 'faraday'
require 'json'
require 'ostruct'
require 'cgi'

module UboostClient

  class Client

    attr_accessor :subdomain, :api_credentials

    def initialize(options = Hash.new)
      @subdomain        = options[:subdomain]
      @api_credentials  = options[:api_credentials]
      @debug            = options[:debug] || false
    end

    def connection
      url = "https://#{@api_credentials[:username]}:#{@api_credentials[:password]}@#{@subdomain}.uboost.com"
      Faraday.new(url) do |faraday|
        faraday.request  :url_encoded               # form-encode POST params
        faraday.response :logger          if @debug # log requests to STDOUT
        faraday.adapter  Faraday.default_adapter    # make requests with Net::HTTP
      end
    end

    def connection_with_uboost_session(uboost_session_id)
      url = "https://#{@subdomain}.uboost.com"
      Faraday.new(url, {:headers=>{'Cookie'=> uboost_session_id}}) do |faraday|
        faraday.request  :url_encoded             # form-encode POST params
        faraday.response :logger        if @debug # log requests to STDOUT
        faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
      end
    end

    def account
      @account ||= UboostClient::Account.new(self)
    end

    def points
      @points ||= UboostClient::Points.new(self)
    end

    def badges
      @badges ||= UboostClient::Badges.new(self)
    end

    def widgets(options = Hash.new)
      @widgets = UboostClient::Widgets.new(self, options)
    end

  end

  class Account
    attr_accessor :client, :url

    def initialize(client)
      @client = client
      @url = '/api/accounts'
    end

    def create(data)
      data = {'account' => data}
      response = client.connection.post do |req|
        req.url @url
        req.headers['Content-Type'] = 'application/json'
        req.body = JSON.generate(data)
      end
      OpenStruct.new(JSON.parse(response.body))
    end

    def select(account_id)
      response = client.connection.get "#{@url}/#{account_id}"
      OpenStruct.new(JSON.parse(response.body))
    end

    def update(account_id, hash)
      data = {'account' => hash}
      response = client.connection.put do |req|
        req.url "#{@url}/#{account_id}"
        req.headers['Content-Type'] = 'application/json'
        req.body = JSON.generate(data)
      end
      OpenStruct.new(JSON.parse(response.body))
    end

    def delete(account_id)
      response = client.connection.delete "#{@url}/#{account_id}"
      OpenStruct.new(JSON.parse(response.body))
    end

    def find(query)
      response = client.connection.get do |req|
        req.url @url + "/find", query
      end
      OpenStruct.new(JSON.parse(response.body))
    end

    def token(id)
      response = client.connection.get "#{@url}/#{id}/sign_in_user"
      OpenStruct.new(JSON.parse(response.body))
    end

    def points_transactions(account_id, options = nil)
      response = client.connection.get do |req|
        req.url @url + "/#{account_id}/points_transactions", options
      end
      OpenStruct.new(JSON.parse(response.body))
    end

  end

  class Points

    attr_accessor :client, :url

    def initialize(client)
      @client = client
      @url = '/api/points_transactions'
    end

    def points_transactions_for_account(id_or_options)
      options = id_or_options
      options = {:account_id => id_or_options} if !id_or_options.is_a? Hash
      response = client.connection.get do |req|
        req.url @url, options
      end
      OpenStruct.new(JSON.parse(response.body))
    end

    def add_points_to_account(id, points, options = nil)
      data = {:points_transaction => {:account_id => id, :points_change => points}}
      data[:points_transaction].merge!(options) if options
      response = client.connection.post do |req|
        req.url @url
        req.headers['Content-Type'] = 'application/json'
        req.body = JSON.generate(data)
      end
      OpenStruct.new(JSON.parse(response.body))
    end

  end

  class Badges

    attr_accessor :client, :url

    def initialize(client)
      @client = client
      @url = '/api/badges'
    end

    def award(account_id, badge_type_id, options = nil)
      data = {:badge => {:account_id => account_id, :badge_type_id => badge_type_id}}
      data[:badge].merge!(options) if options
      response = client.connection.post do |req|
        req.url @url
        req.headers['Content-Type'] = 'application/json'
        req.body = JSON.generate(data)
      end
      OpenStruct.new(JSON.parse(response.body))
    end

    def unaward(account_id, badge_type_id, options = nil)
      data = {:badge => {:account_id => account_id, :badge_type_id => badge_type_id}}
      data[:badge].merge!(options) if options
      response = client.connection.delete do |req|
        req.url @url + "/unaward"
        req.headers['Content-Type'] = 'application/json'
        req.body = JSON.generate(data)
      end
      OpenStruct.new(JSON.parse(response.body))
    end

  end

  class Widgets
    attr_accessor :url, :client, :session

    def initialize(client, options)
      @client = client
      @url = '/api/widgets'
      @session = options[:session] || false
    end

    def session_cache_available?
      @session
    end

    def cached_uboost_id_available?
      @session && @session[:uboost_session_id]
    end

    def get_sso_token(account_id)
      client.account.token(account_id).student["sso_token"]
    end

    def cache_uboost_cookie(response)
      cookie = CGI::Cookie.parse(response.headers['set-cookie'])
      @session[:uboost_session_id] = "_uboost_session_id=" + cookie["_uboost_session_id"][0]
    end
    
    def get(url, options)
      response = nil
      if !session_cache_available?
        response = @client.connection.get url, :sso_token => get_sso_token(options[:account_id])
      elsif !cached_uboost_id_available?
        response = @client.connection.get url, :sso_token => get_sso_token(options[:account_id])
        cache_uboost_cookie(response)
      elsif cached_uboost_id_available?
        response = @client.connection_with_uboost_session(@session[:uboost_session_id]).get url
        cache_uboost_cookie(response)
      end
      response
    end

    def profile(options)
      options = {:account_id => nil}.merge(options)
      response = get(@url + '/profile', options)
      OpenStruct.new(JSON.parse(response.body))
    end

    def my_badges(options)
      options = {:account_id => nil, :badge_category_id => 'all'}.merge(options)
      response = get(@url + '/badges/mine/' + options[:badge_category_id], options)
      OpenStruct.new(JSON.parse(response.body))
    end

    def list_of_leaderboards(options)      
      response = get(@url + '/leaderboards/', options)
      OpenStruct.new(JSON.parse(response.body))
    end

    def leaderboard(options)
      options = {:account_id => nil, :leaderboard_id => nil}.merge(options)
      response = get(@url + '/leaderboards/' + options[:leaderboard_id].to_s, options)
      OpenStruct.new(JSON.parse(response.body))
    end

    def ubar(options = Hash.new)
      options = {:align => "top", :bar_color => '0x222222', :div_id => 'ubar'}.merge(options)
      token = get_sso_token(options[:account_id])
      subdomain_url = "http://" + client.subdomain + ".uboost.com"

"     <script type='text/javascript' src='#{subdomain_url}/javascripts/uBar.js'></script>
      <div class='uboost_ubar' id='#{options[:div_id]}'>
        <object>
          <param value='#{subdomain_url}/uBar.swf' name='movie'>
          <param value='100%' name='width'>
          <param value='100%' name='height'>
          <param value='transparent' name='wmode'>
          <param value='always' name='allowScriptAccess'>
          <param value='url=#{subdomain_url}/ubar/&token=#{token}&align=#{options[:align]}&barColor=#{options[:bar_color]}&divId=#{options[:div_id]}'
           name='flashvars'>
          <param value='false' name='cacheBusting'>
          <param value='true' name='allowFullScreen'>
          <embed width='1280' height='400' wmode='transparent' allowfullscreen='true' quality='high'
            cachebusting='false' flashvars='url=#{subdomain_url}/ubar/&token=#{token}&align=#{options[:align]}&barColor=#{options[:bar_color]}&divId=#{options[:div_id]}'
            allowscriptaccess='always' src='#{subdomain_url}/uBar.swf'>
        </object>
      </div>"
    end
  end

end