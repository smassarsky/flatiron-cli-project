class Player

  @@all = []

  attr_accessor :api_id, :api_link, :first_name, :last_name, :jersey_number, :position, :position_code, :position_type, :team, :nationality, :birth_date, :height, :weight, :captain, :alternate_captain, :shoots

  def initialize(player_hash, team)
    @api_id = player_hash["person"]["id"]
    @api_link = player_hash["person"]["link"]
    @first_name = player_hash["person"]["fullName"].split(" ")[0]
    @last_name = player_hash["person"]["fullName"].split(" ")[1]
    @jersey_number = player_hash["jerseyNumber"]
    @position = player_hash["position"]["name"]
    @position_code = player_hash["position"]["code"]
    @position_type = player_hash["position"]["type"]
    @team = team
    self.class.all << self
  end

  def self.find_or_create_by_name(player_hash, team)
    player = all.find{|player| player.full_name == player_hash["person"]["fullName"]}
    if player
      player
    else
      Player.new(player_hash, team)
    end
  end

  def full_name
    "#{@first_name} #{@last_name}"
  end

  def self.all
    @@all
  end

end