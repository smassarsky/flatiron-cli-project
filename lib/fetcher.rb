class Fetcher

  BASE_URL = 'https://statsapi.web.nhl.com/api/v1/'

  def self.fetch_teams
    uri = URI.parse(BASE_URL + 'teams')
    response = Net::HTTP.get_response(uri)
    teams_hash = JSON.parse(response.body)
    teams_hash["teams"].each do |team_hash|
      Team.find_or_create_by_name(team_hash)
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
  end
  
end