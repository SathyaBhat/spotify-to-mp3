require 'fileutils'
require 'rest-client'
require 'spotify_to_mp3/grooveshark/track'
require 'open-uri'

module SpotifyToMp3
  class Grooveshark
    def initialize(client)
      @client = client
    end

    def get_track(query)
      client_track = @client.search_songs(query).first or raise "Track not found"
      Track.new(client_track)
    end

    def download(track)
      url = @client.get_song_url(track.client_track)
      puts "URL to download: %s" %url      
      # Request.execute causes file to be downloaded incorrectly, use open method as a workaround
      # file = RestClient::Request.execute(:method => :post, :url => url, :raw_response => true).file 
      puts "File name:" + track.filename
      open(track.filename, 'wb') do |file|
        file << open(url).read
      end
      # To fix later, but for now let's just put it in current dir.
      # FileUtils.mv(path, track.filename)
    end
  end
end
