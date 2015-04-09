require 'forecast_io'
require 'openssl'
require 'net/https'
require 'json'
require 'rubygems'
class MainController < ApplicationController
  
  def index
    @main =  Main.getWeather();
    
    cond = @main.currently.icon
    case cond
    when "clear-day" 
      @main.currently.icon = "wi wi-day-sunny"
    when "clear-night"
      @main.currently.icon = "wi wi-night-clear"
    when "rain"
      @main.currently.icon = "wi wi-showers"
    when "snow" 
      @main.currently.icon = "wi wi-snow"
    when "sleet" 
      @main.currently.icon = "wi wi-sleet"  
    when "wind"
      @main.currently.icon = "wi wi-cloudy-windy"  
    when "fog " 
      @main.currently.icon = "wi wi-fog"
    when "cloudy" 
      @main.currently.icon = "wi wi-cloudy"  
    when "partly-cloudy-day" 
      @main.currently.icon = "wi wi-day-sunny-overcast"
    when "partly-cloudy-night" 
      @main.currently.icon = "wi wi-night-cloudy"
    when "hail" 
      @main.currently.icon = "wi wi-hail"
    when "thunderstorm" 
      @main.currently.icon = "wi wi-thunderstorm"
    when "tornado" 
      @main.currently.icon = "wi wi-tornado"
    end
  end
end