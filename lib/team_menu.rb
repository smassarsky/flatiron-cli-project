class Team_Menu < Menu

  def initialize(team)
    @team = team
    @options = ["Show Roster",
                "Current Season Stats",
                "Season Stats by Season",
                "All Seasons Stats",
                "Back",
                "Exit"]
    while true
      team.team_details
      show_options(@options)
      selection = nil
      while selection == nil
        selection = is_valid?(get_input, @options)
      end
      break if go_to_selection(selection) == "break"
    end
  end

  def go_to_selection(selection)
    case selection
    when @options.length - 1
      CLI.exit_program
    when @options.length - 2
      "break"
    when 0
      @team.show_roster
    when 1
      go_to_current_season_stats
    when 2
      go_to_season_stats_by_season
    when 3
      go_to_all_seasons_stats
    end
  end

  def go_to_current_season_stats
    stats_hash = Fetcher.fetch_team_current_season_stats(@team)
    stats_list = season_hash_to_list(stats_hash)
    Stats_Printer.team_single_season(stats_list, @team.full_team_name, "Current")
    puts "\nDisplay extended stats? ('y' or 'yes')\n\n"
    input = get_input
    if input == "y" || input == "yes"
      Stats_Printer.extended_player_season_stats(stats_hash)
      puts "\nAny input to go back."
      gets
    end
  end

  def go_to_season_stats_by_season
    while true
      puts "Please input a season (example format '20192020'):"
      season = get_valid_season
      stats_hash = Fetcher.fetch_team_season_stats_by_season(@team, season)
      if stats_hash != "invalid"
        stats_list = season_hash_to_list(stats_hash)
        Stats_Printer.team_single_season(stats_list, @team.full_team_name, "#{season[0..3]} - #{season[4..7]}")
        puts "\nDisplay extended stats? ('y' or 'yes')\n\n"
        input = get_input
        if input == "y" || input == "yes"
          Stats_Printer.extended_player_season_stats(stats_hash)
          puts "\nAny input to go back."
          gets
        end
        break
      else
        puts "\nInvalid season input\n\n"
        show_options(["Try Again", "Back"])
        break if is_valid?(get_input, ["Try Again", "Back"]) == 1
      end
    end

  end
  
  def go_to_all_seasons_stats
    stats_hash = Fetcher.fetch_team_all_seasons_stats(@team)
    stats_list = stats_hash.map{|season, stats| [season] + season_hash_to_list(stats)}.reverse
    Stats_Printer.team_all_seasons_stats(stats_list, @team.full_team_name)
    puts "\nAny input to go back."
    gets
  end

  def season_hash_to_list(s_h)
    [s_h["gamesPlayed"], s_h["wins"], s_h["losses"], s_h["ot"], s_h["pts"]].map{|stat| stat.to_s}
  end

end