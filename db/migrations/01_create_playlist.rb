Sequel.migration do
  up do 
    create_table :playlists do
      primary_key :id, :null=>false
      String :name
      String :password
    end
  end

  down do
    drop_table :playlists
  end
end