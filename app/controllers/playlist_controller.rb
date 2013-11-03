class PlaylistController < ApplicationController
  enable :sessions

  get '/spotify/:slug' do
    @queries = Spotify_Finder.search(params[:search])
    session[:queries] = @queries
    redirect "/playlist/#{params[:slug]}"
  end

   get '/playlist/:slug' do 
    @queries = session[:queries]
    session[:bad_login] = nil
    session[:room_exists] = false
    @playlist = Playlist.find(slug: params[:slug])
    @current_song = @playlist.current_song
    @songs = @playlist.songs_in_queue
    erb :'playlist'
  end

  post '/playlist/:slug/add' do
    @song = Playlist.find(slug: params[:slug]).add_song(params[:song], request.ip)
    if @song == :user_limit_met
      redirect "/playlist/#{params[:slug]}/user_limit"
    elsif @song == :playlist_full
      redirect "/playlist//#{params[:slug]}/full"
    end
    session[:queries] = nil
    redirect "/playlist/#{params[:slug]}"
  end

  get '/playlist/:slug/user_limit' do
    @playlist = Playlist.find(slug: params[:slug])
    erb :user_limit
  end

  get '/playlist/:slug/full' do
    @playlist = Playlist.find(slug: params[:slug])
    erb :playlist_full
  end

 
  get '/playlist/:slug/songs/:id/upvote' do
    @song = Playlist.find(slug: params[:slug]).songs.detect {|song| song.id == params[:id].to_i}
    @song.vote(request.ip)
    redirect "/playlist/#{params[:slug]}"
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