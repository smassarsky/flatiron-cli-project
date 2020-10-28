class Fetcher

  BASE_URL = 'https://statsapi.web.nhl.com/api/v1/'

  def self.fetch_teams
    uri = URI.parse(BASE_URL + 'teams')
    response = Net::HTTP.get_response(uri)
    teams_hash = JSON.parse(response.body)
    teams_hash["teams"].each do |team_hash|
      Team.find_or_create_by_hash(team_hash)
    end
  end

  def self.fetch_players(team)
    uri = URI.parse(BASE_URL + "teams/#{team.api_id}/roster")
    response = Net::HTTP.get_response(uri)
    roster_hash = JSON.parse(response.body)
    roster_hash["roster"].each do |player|
      Player.find_or_create_by_name(player, team)
    end
    team.fetched_players = true
  end

  def self.fetch_extra_player_info(player)
    uri = URI.parse(BASE_URL + "people/#{player.api_id}/")
    response = Net::HTTP.get_response(uri)
    player.update_extra_details(JSON.parse(response.body)["people"][0])
    player.extra_details_fetch = true
  end

  def self.fetch_player_stats_current_season(player)
    uri = URI.parse(BASE_URL + "people/#{player.api_id}/?expand=person.stats&stats=statsSingleSeason")
    response = Net::HTTP.get_response(uri)
    JSON.parse(response.body)["people"][0]["stats"][0]["splits"][0]["stat"]
  end

  def self.fetch_player_stats_by_season(player, season)
    uri = URI.parse(BASE_URL + "people/#{player.api_id}/?expand=person.stats&stats=statsSingleSeason&season=" + season)
    response = Net::HTTP.get_response(uri)
    hash = JSON.parse(response.body)
    if hash["people"][0]["stats"][0]["splits"] != []
      hash["people"][0]["stats"][0]["splits"][0]["stat"]
    else
      "invalid"
    end
  end

  def self.fetch_player_all_seasons_stats_all(player)
    uri = URI.parse(BASE_URL + "people/#{player.api_id}/?expand=person.stats&stats=yearByYear")
    response = Net::HTTP.get_response(uri)
    JSON.parse(response.body)["people"][0]["stats"][0]["splits"].select{|x| x["league"]["name"] == "National Hockey League"}
  end

  def self.fetch_career_stats(player)
    uri = URI.parse(BASE_URL + "people/#{player.api_id}/?expand=person.stats&stats=careerRegularSeason")
    response = Net::HTTP.get_response(uri)
    JSON.parse(response.body)["people"][0]["stats"][0]["splits"][0]["stat"]
  end

  def self.fetch_team_current_season_stats(team)
    uri = URI.parse(BASE_URL + "teams/#{team.api_id}/stats")
    response = Net::HTTP.get_response(uri)
    JSON.parse(response.body)["stats"][0]["splits"][0]["stat"]
  end

  def self.fetch_team_season_stats_by_season(team, season)
    uri = URI.parse(BASE_URL + "teams/#{team.api_id}/stats?season=" + season)
    response = Net::HTTP.get_response(uri)
    hash = JSON.parse(response.body)
    if hash["stats"][0]["splits"] != []
      hash["stats"][0]["splits"][0]["stat"]
    else
      "invalid"
    end
  end

  def self.fetch_team_all_seasons_stats(team)
    stats_hash = {}
    year = team.first_year_of_play.to_i
    while year <= Time.now.year
      season = "#{year}#{year + 1}"
      temp = fetch_team_season_stats_by_season(team, season)
      stats_hash[season] = temp if temp != "invalid"
      year += 1
    end
    stats_hash
  end
  
end