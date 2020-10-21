class Team

  @@all = []

  attr_accessor :name, :city, :abbreviation, :venue, :website, :first_year_of_play, :division, :conference, :api_id, :api_url, :fetched_players

  def initialize(team_hash)
    @name = team_hash["teamName"]
    @city = team_hash["locationName"]
    @abbreviation = team_hash["abbreviation"]
    @venue = team_hash["venue"]["name"]
    @website = team_hash["officialSiteUrl"]
    @first_year_of_play = team_hash["firstYearOfPlay"]
    @division = team_hash["division"]["name"]
    @conference = team_hash["conference"]["name"]
    @api_id = team_hash["id"]
    @api_url = team_hash["link"]
    @fetched_players = false
    self.class.all << self
  end

  def self.find_or_create_by_hash(team_hash)
    team = all.find{|team| team.full_team_name == team_hash[name]}
    if team
      team
    else
      Team.new(team_hash)
    end
  end

  def self.all_team_names
    all.map{|team| team.full_team_name}
  end

  def self.find_by_name(name)
    all.find{|team| team.full_team_name == name}
  end

  def team_details
    puts "\n***************************************"
    puts "Team Name: #{full_team_name}"
    puts "Abbreviation: #{@abbreviation}"
    puts "Conference: #{@conference}"
    puts "Division: #{@division}"
    puts "Arena: #{@venue}"
    puts "First Year of Play: #{@first_year_of_play}"
    puts "Website: #{@website}"
    puts "***************************************\n\n"
  end

  def show_roster
    if !@fetched_players
      Fetcher.fetch_players(self)
    end
    Players_List_Menu.new(Player.players_by_team(self), self)
  end

  def self.check_all_fetched_players
    all.each do |team|
      Fetcher.fetch_players(team) if !team.fetched_players
    end
  end

  def self.conferences
    all.map{|team| team.conference}.uniq
  end

  def self.divisions
    all.map{|team| team.division}.uniq
  end

  def self.teams_in_conference(conference)
    all.select{|team| team.conference == conference}
  end

  def self.teams_in_division(division)
    all.select{|team| team.division == division}
  end

  def full_team_name
    "#{@city} #{@name}"
  end

  def self.all
    @@all
  end

end