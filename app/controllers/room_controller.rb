class RoomController < ApplicationController

  get '/' do 
    erb :index
  end

  post '/playlist' do
    Playlist.create(params[:playlist])
    redirect "/playlist/#{params[:playlist][:name]}"
  end

end