class Team

  @@all = []

  attr_accessor :name, :city, :abbreviation, :venue, :website, :first_year_of_play, :division, :conference, :api_id, :api_url

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
    self.class.all << self
  end

  def self.find_or_create_by_name(team_hash)
    team = all.find{|team| team.full_team_name == team_hash[name]}
    if team
      team
    else
      Team.new(team_hash)
    end
  end

  def full_team_name
    "#{@city} #{@name}"
  end

  def self.all
    @@all
  end

end