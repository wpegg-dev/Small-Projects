class PlaybackControllerController < ApplicationController
   def index
    @songs = Dir.entries("#{Rails.root}/app/assets/audios")
    @songs.delete("..")
    @songs[0] = "Select a Song"
   end
end
