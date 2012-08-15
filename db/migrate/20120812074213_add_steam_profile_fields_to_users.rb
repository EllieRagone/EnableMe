class AddSteamProfileFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :steam_id, :string
    add_column :users, :privacy_state, :string
    add_column :users, :avatar_icon, :string
    add_column :users, :avatar_medium, :string
    add_column :users, :avatar_full, :string
    add_column :users, :custom_url, :string
    add_column :users, :steam_rating, :float
    add_column :users, :hours_played_2wk, :float
    add_column :users, :real_name, :string
  end
end
