class Fetcher

  BASE_URL = 'https://statsapi.web.nhl.com/api/v1/'

  def fetch_teams
    uri = URI.parse(BASE_URL + 'teams')
    response = Net::HTTP.get_response(uri)
    teams_hash = JSON.parse(response.body)
    teams_hash["teams"].each do |team_hash|
      Team.find_or_create_by_name(team_hash)
    end
  end

  def fetch_players(team)
    uri = URI.parse(BASE_URL + "teams/#{team.api_id}/roster")
    response = Net::HTTP.get_response(uri)
    roster_hash = JSON.parse(response.body)
    roster_hash["roster"].each do |player|
      Player.find_or_create_by_name(player, team)
    end
  end
  
end