# == Schema Information
#
# Table name: users
#
#  id               :integer          not null, primary key
#  steam_name       :string(255)
#  email            :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  password_digest  :string(255)
#  remember_token   :string(255)
#  admin            :boolean          default(FALSE)
#  steam_games      :text
#  steam_id         :string(255)
#  privacy_state    :string(255)
#  avatar_icon      :string(255)
#  avatar_medium    :string(255)
#  avatar_full      :string(255)
#  custom_url       :string(255)
#  steam_rating     :float
#  hours_played_2wk :float
#  real_name        :string(255)
#  steam_id_64      :string(255)
#

class User < ActiveRecord::Base
  attr_accessible :email, :steam_name, :password, :password_confirmation
  has_secure_password
  serialize :steam_games, Hash

  before_save { self.email.downcase! }
  before_save :create_remember_token
  before_save :get_steam_games
  before_save :get_steam_profile

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :steam_name, presence: true
  validates :email,      presence: true,
                         format: { with: VALID_EMAIL_REGEX },
                         uniqueness: { case_sensitive: false }
  validates :password,   length: { minimum: 6 }
  validates :password_confirmation, presence: true


private
  require 'open-uri'

  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end

  BASE_URL = "http://steamcommunity.com/id/"
  END_URL_GAMES = "/games/?tab=all&sort=name&xml=1"
  END_URL_PROFILE = "?xml=1"

  def get_steam_games
    steam_games_xml = Crack::XML.parse(RestClient.get(URI.encode("#{BASE_URL}#{steam_name}#{END_URL_GAMES}")))
    # Steam_games_array is an array of hashes.
    # Each hash has keys: appID, name, logo, storeLink, hoursLast2Weeks, hoursOnRecord.
    # It is transferred into a hash of hashes, with the appID being the key, and the above hash being the value
    steam_games_array = steam_games_xml['gamesList']['games']['game']
    steam_games_new = steam_games_array.inject({}) do |result, game_listing|
      result[game_listing['appID']] = game_listing
      result
    end
    add_to_steam_games = steam_games_new.keys - steam_games.keys
    add_to_steam_games.each do |key| 
      self.steam_games[key] = steam_games_new[key]
      self.steam_games[key]['user_rating'] = false
      self.steam_games[key]['expected_rating'] = false
    end
  end


  def get_steam_profile
    steam_profile_xml = Crack::XML.parse(RestClient.get(URI.encode("#{BASE_URL}#{steam_name}#{END_URL_PROFILE}")))
    # Steam_profile is a hash.
    # It has the following keys: 
    #      steamID64
    ##     steamID => string ("[GWJ]StaggerLee")
    #      onlineState => string ("offline")
    #      stateMessage => string ("Last Online: x days ago")
    ##     privacyState => string ("public")
    #      visibilityState => integer as string
    ##     avatarIcon => url_string
    ##     avatarMedium => url_string
    ##     avatarFull => url_string
    #      vacBanned => integer as string
    #      tradeBanState => string
    #      isLimitedAccount => integer as string
    ##     customURL => string ("rafer32")
    #      memberSince => string ("August 18, 2008")
    ##     steamRating => float as string ("0.6")
    ##     hoursPlayed2Wk => float as string ("1.9")
    #      headline
    #      location => string ("California, United States")
    ##     realname => string ("StaggerLee")
    #      summary => string ("No information given.")
    #      mostPlayedGames => hash of hashes
    #      groups => hash of array of hashes
    steam_profile = steam_profile_xml['profile']

    self.steam_id_64 = steam_profile['steamID64']
    self.steam_id = steam_profile['steamID']
    self.privacy_state = steam_profile['privacyState']
    self.avatar_icon = steam_profile['avatarIcon']
    self.avatar_medium = steam_profile['avatarMedium']
    self.avatar_full = steam_profile['avatarFull']
    self.custom_url = steam_profile['customURL']
    self.steam_rating = steam_profile['steamRating']
    self.hours_played_2wk = steam_profile['hoursPlayed2Wk']
    self.real_name = steam_profile['realname']
  end

end
