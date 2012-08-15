class AddSteamId64ToUsers < ActiveRecord::Migration
  def change
    add_column :users, :steam_id_64, :string
  end
end
