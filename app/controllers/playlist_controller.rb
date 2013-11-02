class PlaylistController < ApplicationController
  enable :sessions

  # def upvote_or_unvote(song, ip)
  #   if session[:song_votes].keys.include?(song.id)
  #     if session[:song_votes][song.id].include?(ip)
  #       song.unvote
  #       session[:song_votes][song.id].delete(ip)
  #     else
  #       song.upvote
  #       session[:song_votes][song.id] << ip
  #     end
  #   end
  # end


  get '/spotify/:name' do
    @queries = Spotify_Finder.search(params[:search])
    session[:queries] = @queries
    redirect "/playlist/#{params[:name]}"
  end

   get '/playlist/:name' do 
    @queries = session[:queries]
    @playlist = Playlist.find(name: params[:name])
    @current_song = @playlist.current_song
    @songs = @playlist.songs_in_queue
    erb :'playlist'
  end

  post '/playlist/:name/add' do
    @song = Playlist.find(name: params[:name]).add_song(params[:song], request.ip)
    if @song == :user_limit_met
      redirect "/playlist/#{params[:name]}/user_limit"
    elsif @song == :playlist_full
      redirect "/playlist//#{params[:name]}/full"
    end
    session[:queries] = nil
    redirect "/playlist/#{params[:name]}"
  end

  get '/playlist/:name/user_limit' do
    @playlist = Playlist.find(name: params[:name])
    erb :user_limit
  end

  get '/playlist/:name/full' do
    @playlist = Playlist.find(name: params[:name])
    erb :playlist_full
  end

 
  get '/playlist/:name/songs/:id/upvote' do
    @song = Playlist.find(name: params[:name]).songs.detect {|song| song.id == params[:id].to_i}
    @song.vote(request.ip)
    redirect "/playlist/#{params[:name]}"
  end

end

# HEROKU OR RASPBERRY PI

# master page
#   -master user creates 'room' with name and password
#   -teather to spotify login
#   -master streams songs
#   -has user page functionality

# user page



# duplication!
# Spotify functionality
# AJAX
#   -search results
#   -list sorting by vote count
#   -
# Where to play the song?
#   -adding to database with after_play callback
#   -removing song from list with after_play callback
# CSS/ page design
# archive/ history page?
# server/ database