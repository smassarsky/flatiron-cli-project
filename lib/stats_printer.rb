class Stats_Printer

  def self.player_individual_season(stats, name, season)
    puts "\n#{name} #{season} Season Stats\n\n"
    puts "| Games | +/- | Goals | Assists | Points | Hits | Faceoff % | Time on Ice |"
    puts "|-------|-----|-------|---------|--------|------|-----------|-------------|"
    columns = [7, 5, 7, 9, 8, 6, 11, 13]
    stats_str = "|"
    stats.each_with_index{ |stat, index| stats_str << stat.center(columns[index]) + "|" }
    puts stats_str
  end

  def self.player_multiple_season(all_stats, name)
    puts "\n#{name} All NHL Seasons Stats\n\n"
    columns = [10, all_stats.map{|season| season[1].length}.max + 2, 7, 5, 7, 9, 8, 6, 11, 13]
    puts "|  Season  |" + "Team".center(columns[1]) + "| Games | +/- | Goals | Assists | Points | Hits | Faceoff % | Time on Ice |"
    puts "|----------|"+ "-".center(columns[1], "-") + "|-------|-----|-------|---------|--------|------|-----------|-------------|"
    all_stats.each do |stats|
      stats_str = "|"
      stats.each_with_index{ |stat, index| stats_str << stat.center(columns[index]) + "|" }
      puts stats_str
    end
  end
  
  def self.extended_player_season_stats(stats_hash)
    puts
    stats_hash.each{|key, value| puts key.split(/(?=[A-Z])/).map{|x| x.capitalize}.join(" ") + " : #{value}"}
  end

  def self.team_single_season(stats, team_name, season)
    puts "\n#{team_name} #{season} Season Stats\n\n"
    puts "| Games Played | Wins | Losses | OT Losses | Points |"
    columns = [14, 6, 8, 11, 8]
    stats_str = "|"
    stats.each_with_index{ |stat, index| stats_str << stat.center(columns[index]) + "|" }
    puts stats_str
  end

  def self.team_all_seasons_stats(all_stats, team_name)
    puts "\n#{team_name} All Seasons Stats\n\n"
    puts "|  Season  | Games Played | Wins | Losses | OT Losses | Points |"
    columns = [10, 14, 6, 8, 11, 8]
    all_stats.each do |stats|
      stats_str = "|"
      stats.each_with_index{ |stat, index| stats_str << stat.center(columns[index]) + "|" }
      puts stats_str
    end
  end

end
