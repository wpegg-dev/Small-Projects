require 'forecast_io'
require 'openssl'
require 'net/https'
require 'json'

class Main < ActiveRecord::Base
  OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
  
  ForecastIO.configure do |configuration|
    configuration.api_key = '[my api key]'
  end  
  
  def self.getWeather()
    forecast = ForecastIO.forecast(33.7550, 84.3900)
    return forecast
  end
end
