class Player_Menu < Menu

  OPTIONS = ["Current Season Stats", "Stats by Season", "All Seasons Stats", "Career Stats", "Back", "Exit"]

  def initialize(player)
    @player = player
    while true
      @player.display_player_info
      selection = show_options_and_get_valid_input(OPTIONS)
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
    display_extended_stats?(stats_hash)
  end

  def go_to_stats_by_season
    while true
      season = get_valid_season
      break if season == nil
      stats_hash = Fetcher.fetch_player_stats_by_season(@player, season)
      if stats_hash != "invalid"
        stats_list = stats_hash_to_list(stats_hash)
        Stats_Printer.player_individual_season(stats_list, @player.full_name, "#{season[0..3]} - #{season[4..7]}")
        display_extended_stats?(stats_hash)
        break
      else
        puts "\nInvalid season input\n\n"
        break if try_again_or_go_back == 1
      end
    end
  end

  def go_to_all_seasons_stats
    stats_list = Fetcher.fetch_player_all_seasons_stats_all(@player)
    stats_list = stats_list.reverse.map{ |set| [set["season"], set["team"]["name"]] + stats_hash_to_list(set["stat"]) }
    Stats_Printer.player_multiple_season(stats_list, @player.full_name)
    any_input_to_go_back
  end

  def go_to_career_stats
    stats_hash = Fetcher.fetch_career_stats(@player)
    stats_list = stats_hash_to_list(stats_hash)
    Stats_Printer.player_individual_season(stats_list, @player.full_name, "Career")
    display_extended_stats?(stats_hash)
  end

  def stats_hash_to_list(s_h)
    [s_h["games"], s_h["plusMinus"], s_h["goals"], s_h["assists"], s_h["points"], s_h["hits"], s_h["faceOffPct"], s_h["timeOnIce"]].map{|stat| stat.to_s}
  end

end