class Team_Menu < Menu

  OPTIONS = ["Show Roster",
             "Current Season Stats",
             "Season Stats by Season",
             "All Seasons Stats",
             "Back",
             "Exit"]

  def initialize(team)
    @team = team
    while true
      @team.team_details
      selection = show_options_and_get_valid_input(OPTIONS)
      break if go_to_selection(selection) == "break"
    end
  end

  def go_to_selection(selection)
    case selection
    when OPTIONS.length - 1
      CLI.exit_program
    when OPTIONS.length - 2
      "break"
    when 0
      go_to_roster
    when 1
      go_to_current_season_stats
    when 2
      go_to_season_stats_by_season
    when 3
      go_to_all_seasons_stats
    end
  end

  def go_to_roster
    if !@team.fetched_players
      Fetcher.fetch_players(@team)
    end
    Players_List_Menu.new(Player.players_by_team(@team), @team)
  end

  def go_to_current_season_stats
    stats_hash = Fetcher.fetch_team_current_season_stats(@team)
    stats_list = season_hash_to_list(stats_hash)
    Stats_Printer.team_single_season(stats_list, @team.full_team_name, "Current")
    display_extended_stats?(stats_hash)
  end

  def go_to_season_stats_by_season
    while true
      season = get_valid_season
      break if season == nil
      stats_hash = Fetcher.fetch_team_season_stats_by_season(@team, season)
      if stats_hash != "invalid"
        stats_list = season_hash_to_list(stats_hash)
        Stats_Printer.team_single_season(stats_list, @team.full_team_name, "#{season[0..3]} - #{season[4..7]}")
        display_extended_stats?(stats_hash)
        break
      else
        puts "\nInvalid season input\n\n"
        break if try_again_or_go_back == 1
      end
    end

  end
  
  def go_to_all_seasons_stats
    stats_hash = Fetcher.fetch_team_all_seasons_stats(@team)
    stats_list = stats_hash.map{|season, stats| [season] + season_hash_to_list(stats)}.reverse
    Stats_Printer.team_all_seasons_stats(stats_list, @team.full_team_name)
    any_input_to_go_back
  end

  def season_hash_to_list(s_h)
    [s_h["gamesPlayed"], s_h["wins"], s_h["losses"], s_h["ot"], s_h["pts"]].map{|stat| stat.to_s}
  end

end