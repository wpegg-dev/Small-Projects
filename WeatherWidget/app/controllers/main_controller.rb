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
    
    weekHash = @main.daily
    
    weekHash.each do |key, value|
      curItem = weekHash[key]
      @daily = weekHash.to_a
    end
    
    tmpArry = @daily[2][1]
    tmpArry.each do |elem|
      cond = elem.icon
      case cond
      when "clear-day" 
        elem.icon = "wi wi-day-sunny"
      when "clear-night"
        elem.icon = "wi wi-night-clear"
      when "rain"
        elem.icon = "wi wi-showers"
      when "snow" 
        elem.icon = "wi wi-snow"
      when "sleet" 
        elem.icon = "wi wi-sleet"  
      when "wind"
        elem.icon = "wi wi-cloudy-windy"  
      when "fog " 
        elem.icon = "wi wi-fog"
      when "cloudy" 
        elem.icon = "wi wi-cloudy"  
      when "partly-cloudy-day" 
        elem.icon = "wi wi-day-sunny-overcast"
      when "partly-cloudy-night" 
        elem.icon = "wi wi-night-cloudy"
      when "hail" 
        elem.icon = "wi wi-hail"
      when "thunderstorm" 
        elem.icon = "wi wi-thunderstorm"
      when "tornado" 
        elem.icon = "wi wi-tornado"
      end
    end
    
  end
    
end