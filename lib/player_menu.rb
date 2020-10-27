class Player_Menu < Menu

  def initialize(player)
    @options = ["Current Season Stats", "Stats by Season", "All Seasons Stats", "Career Stats", "Back", "Exit"]
    @player = player
    while true
      @player.display_player_info
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
    when 0
      go_to_current_season_stats
    when 1
      go_to_stats_by_season
    when 2
      go_to_all_seasons_stats
    when 3
      go_to_career_stats
    when 4
      "break"
    when 5
      CLI.exit_program
    end
  end

  def go_to_current_season_stats
    stats_hash = Fetcher.fetch_player_stats_current_season(@player)
    stats_list = stats_hash_to_list(stats_hash)
    Stats_Printer.player_individual_season(stats_list, @player.full_name, "Current")
    puts "\nDisplay extended stats? ('y' or 'yes')"
    input = get_input
    if input == "y" || input == "yes"
      Stats_Printer.extended_player_season_stats(stats_hash)
      puts "\nAny input to go back."
      gets
    end
  end

  def go_to_stats_by_season
    while true
      puts "Please input a season (example format '20192020'):"
      season = get_valid_season
      stats_hash = Fetcher.fetch_player_stats_by_season(@player, season)
      if stats_hash != "invalid"
        stats_list = stats_hash_to_list(stats_hash)
        Stats_Printer.player_individual_season(stats_list, @player.full_name, "#{season[0..3]} - #{season[4..7]}")
        puts "\nDisplay extended stats? ('y' or 'yes')"
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
    stats_list = Fetcher.fetch_player_all_seasons_stats_all(@player)
    stats_list = stats_list.reverse.map{ |set| [set["season"], set["team"]["name"]] + stats_hash_to_list(set["stat"]) }
    Stats_Printer.player_multiple_season(stats_list, @player.full_name)
    puts "\nAny input to go back."
    gets
  end

  def go_to_career_stats
    stats_hash = Fetcher.fetch_career_stats(@player)
    stats_list = stats_hash_to_list(stats_hash)
    Stats_Printer.player_individual_season(stats_list, @player.full_name, "Career")
    puts "\nDisplay extended stats? ('y' or 'yes')"
    input = get_input
    if input == "y" || input == "yes"
      Stats_Printer.extended_player_season_stats(stats_hash)
      puts "\nAny input to go back."
      gets
    end
  end

  def stats_hash_to_list(s_h)
    [s_h["games"], s_h["plusMinus"], s_h["goals"], s_h["assists"], s_h["points"], s_h["hits"], s_h["faceOffPct"], s_h["timeOnIce"]].map{|stat| stat.to_s}
  end

end