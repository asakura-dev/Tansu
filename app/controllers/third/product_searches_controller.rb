module Third
  class ProductSearchesController < ApplicationController
    before_action :authenticate_user!
    before_action :owner_or_manager
    def show
      if ["isbn", "query"].include?(params["type"])
        response_data = search_from_yahoo(params["type"],params["value"])
      end
    ennd
    private
    def search_from_yahoo(type, value)
      yahoo_api = Faraday.new(:url => 'http://shopping.yahooapis.jp') do |faraday|
        faraday.request  :url_encoded             # form-encode POST params
        faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
      end
      res = yahoo_api.get do |req|
        req.url '/ShoppingWebService/V1/json/itemSearch'
        req.params['appid'] = Tansu::Application.config.yahoo_application_id
        req.params[type] = value
      end
      JSON.parse(res.body)
    end
    
  end
end
