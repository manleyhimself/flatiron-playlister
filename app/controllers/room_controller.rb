class RoomController < ApplicationController
  enable :sessions
 
  get '/' do 
    @bad_login = session[:bad_login]
    @room_exists = session[:room_exists]
    erb :index
  end

  post '/playlist/create' do
    if Playlist.find(name: params[:playlist][:name])
      session[:room_exists] = true
      session[:bad_login] = false
      redirect '/'
    else
      @playlist = Playlist.create(params[:playlist])
      redirect "/playlist/#{@playlist.slug}"
    end
  end

  post '/playlist/join' do
    session[:room_exists] = false
    session[:bad_login] = true
    @playlist = Playlist.find(name: params[:playlist][:name])
    redirect '/' if !@playlist
    @playlist.verify_password(params[:playlist][:password]) ? redirect("/playlist/#{@playlist.slug}") : redirect('/')
  end

end


