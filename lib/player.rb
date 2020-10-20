class Player

  @@all = []

  attr_accessor :api_id, :api_link, :first_name, :last_name, :jersey_number, :position, :position_abbreviation, :position_type, :team, :nationality, :birth_date, :height, :weight, :captain, :alternate_captain, :shoots

  def initialize(player_hash, team)
    @api_id = player_hash["person"]["id"]
    @api_link = player_hash["person"]["link"]
    @first_name = player_hash["person"]["fullName"].split(" ")[0]
    @last_name = player_hash["person"]["fullName"].split(" ")[1]
    @jersey_number = player_hash["jerseyNumber"]
    @position = player_hash["position"]["name"]
    @position_abbreviation = player_hash["position"]["abbreviation"]
    @position_type = player_hash["position"]["type"]
    @team = team
    @extra_details_fetch = false
    self.class.all << self
  end

  def player_info
    if !@extra_details_fetch
      Fetcher.fetch_extra_player_info(self)
    end
    puts "***************************************"
    puts "Player Name: #{'(C) ' if @captain}#{'(A) ' if @alternate_captain}#{full_name}"
    puts "Position: #{@position}"
    puts "Jersey Number: #{@jersey_number}"
    puts "Team: #{@team.full_team_name}"
    puts "Nationality: #{@nationality}"
    puts "Birth Date: #{@birth_date}"
    puts "Height: #{@height}"
    puts "Weight: #{@weight}"
    puts "Shoots: #{@shoots == 'L' ? 'Left Handed' : 'Right Handed'}"
  end

  def update_extra_details(details_hash)
    @nationality = details_hash["nationality"]
    @birth_date = details_hash["birthDate"]
    @height = details_hash["height"]
    @weight = details_hash["weight"]
    @captain = details_hash["captain"]
    @alternate_captain = details_hash["alternateCaptain"]
    @shoots = details_hash["shootsCatches"]
    @extra_details_fetch = true
  end

  def self.find_or_create_by_name(player_hash, team)
    player = all.find{|player| player.full_name == player_hash["person"]["fullName"]}
    if player
      player
    else
      Player.new(player_hash, team)
    end
  end

  def self.players_by_team(team)
    puts "#{team.full_team_name} roster:"
    roster = all.select{|player| player.team == team}
    roster = roster.sort_by{|player| player.position_abbreviation}
    roster.each_with_index{|player, index| puts "#{player.position_abbreviation} - #{player.jersey_number} -  #{player.full_name}"}
    puts "Select jersey number or name for more information, or 'back' / 'exit'."
    while true
      selection = get_input(roster)
      break if go_to_selection(selection) == "break"
    end
    binding.pry
  end

  def self.all_players_menu
    puts "TODO"
  end

  def self.get_input(roster)
    input = gets.chomp.downcase
    while select_valid_option(input, roster) == nil
      puts "invalid"
      input = gets.chomp.downcase
    end
    select_valid_option(input, roster)
  end

  def self.select_valid_option(input, roster)
    if input == "back" || input == "exit"
      input
    elsif input == ""
      nil
    elsif input.to_i < 1
      roster.find{|player| player.full_name == input}.jersey_number
    else
      roster.find{|player| player.jersey_number == input}
    end
  end

  def self.go_to_selection(selection)
    if selection == "exit"
      CLI.exit_program
    elsif selection == "back"
      "break"
    else
      selection.player_info
    end
  end

  def full_name
    "#{@first_name} #{@last_name}"
  end

  def self.all
    @@all
  end

end