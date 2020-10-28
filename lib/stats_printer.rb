class Stats_Printer

  def self.player_individual_season(stats, name, season)
    headers = ["Games", "+/-", "Goals", "Assists", "Points", "Hits", "Faceoff %", "Time on Ice"]
    widths = set_column_widths([headers, stats])
    puts "#{name} #{season} Season Stats\n\n"
    general_printer(widths, headers, [stats])
  end

  def self.player_multiple_season(all_stats, name)
    headers = ["Season", "Team", "Games", "+/-", "Goals", "Assists", "Points", "Hits", "Faceoff %", "Time on Ice"]
    widths = set_column_widths([headers] + all_stats)
    puts "#{name} All NHL Seasons Stats\n\n"
    general_printer(widths, headers, all_stats)
  end
  
  def self.team_single_season(stats, team_name, season)
    headers = ["Games Played", "Wins", "Losses", "OT Losses", "Points"]
    widths = set_column_widths([headers, stats])
    puts "#{team_name} #{season} Season Stats\n\n"
    general_printer(widths, headers, [stats])
  end

  def self.team_all_seasons_stats(all_stats, team_name)
    headers = ["Season", "Games Played", "Wins", "Losses", "OT Losses", "Points"]
    totals = ["All Time"]
    5.times{ |x| totals << all_stats.map{ |season| season[x + 1].to_i }.sum.to_s }
    widths = set_column_widths([headers, totals] + all_stats)
    puts "#{team_name} All Seasons Stats\n\n"
    general_printer(widths, headers, all_stats, totals)
  end

  def self.extended_season_stats(stats_hash)
    puts
    stats_hash.each{|key, value| puts key.split(/(?=[A-Z])/).map{|x| x.capitalize}.join(" ") + " : #{value}"}
  end

  def self.general_printer(widths, headers, stats, totals = nil)
    row_printer(widths, headers)
    spacer_printer(widths)
    stats.each {|stats| row_printer(widths, stats)}
    if totals != nil
      spacer_printer(widths)
      row_printer(widths, totals)
    end
  end

  def self.set_column_widths(data)
    widths = []
    data[0].length.times{|x| widths << data.map{|row| row[x].length}.max + 2}
    widths
  end

  def self.row_printer(widths, stats)
    stats_str = "|"
    stats.each_with_index{ |stat, index| stats_str << stat.center(widths[index]) + "|" }
    puts stats_str
  end
  
  def self.spacer_printer(widths)
    spacer_str = "|"
    widths.each{|x| spacer_str << "-".center(x, "-") + "|" }
    puts spacer_str
  end

end
