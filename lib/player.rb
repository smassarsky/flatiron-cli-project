class Player

  @@all = []

  attr_accessor :api_id, :api_link, :first_name, :last_name, :jersey_number, :position, :position_abbreviation, :position_type, :team, :nationality, :birth_date, :height, :weight, :captain, :alternate_captain, :shoots, :extra_details_fetch

  def initialize(player_hash, team)
    @api_id = player_hash["person"]["id"]
    @api_link = player_hash["person"]["link"]
    @first_name = player_hash["person"]["fullName"].split(" ")[0]
    @last_name = player_hash["person"]["fullName"].split(" ")[1]
    @jersey_number = player_hash["jerseyNumber"]
    @position = player_hash["position"]["name"]
    @position_abbreviation = player_hash["position"]["abbreviation"]
    @position_type = player_hash["position"]["type"]
    @team = team
    @extra_details_fetch = false
    self.class.all << self
  end

  def display_player_info
    Fetcher.fetch_extra_player_info(self) if !@extra_details_fetch
    puts "***************************************"
    puts "Player Name: #{'(C) ' if @captain}#{'(A) ' if @alternate_captain}#{full_name}"
    puts "Position: #{@position}"
    puts "Jersey Number: #{@jersey_number}"
    puts "Team: #{@team.full_team_name}"
    puts "Nationality: #{@nationality}"
    puts "Birth Date: #{@birth_date}"
    puts "Height: #{@height}"
    puts "Weight: #{@weight}"
    puts "Shoots: #{@shoots == 'L' ? 'Left Handed' : 'Right Handed'}"
    puts "***************************************\n\n"
  end

  def update_extra_details(details_hash)
    @nationality = details_hash["nationality"]
    @birth_date = details_hash["birthDate"]
    @height = details_hash["height"]
    @weight = details_hash["weight"]
    @captain = details_hash["captain"]
    @alternate_captain = details_hash["alternateCaptain"]
    @shoots = details_hash["shootsCatches"]
    @extra_details_fetch = true
  end

  def self.find_or_create_by_name(player_hash, team)
    player = all.find{|player| player.full_name == player_hash["person"]["fullName"]}
    if player
      player
    else
      Player.new(player_hash, team)
    end
  end

  def self.players_by_team(team)
    all.select{|player| player.team == team}
  end

  def full_name
    "#{@first_name} #{@last_name}"
  end

  def self.all
    @@all
  end

end