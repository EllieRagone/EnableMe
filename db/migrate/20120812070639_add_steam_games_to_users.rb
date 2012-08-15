class AddSteamGamesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :steam_games, :text
  end
end
