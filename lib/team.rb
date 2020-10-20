class Team

  @@all = []

  ALL_TEAMS_TEXTS = ["Please select a team for more information:"]


  attr_accessor :name, :city, :abbreviation, :venue, :website, :first_year_of_play, :division, :conference, :api_id, :api_url, :fetched_players

  def initialize(team_hash)
    @name = team_hash["teamName"]
    @city = team_hash["locationName"]
    @abbreviation = team_hash["abbreviation"]
    @venue = team_hash["venue"]["name"]
    @website = team_hash["officialSiteUrl"]
    @first_year_of_play = team_hash["firstYearOfPlay"]
    @division = team_hash["division"]["name"]
    @conference = team_hash["conference"]["name"]
    @api_id = team_hash["id"]
    @api_url = team_hash["link"]
    @fetched_players = false
    self.class.all << self
  end

  def self.find_or_create_by_name(team_hash)
    team = all.find{|team| team.full_team_name == team_hash[name]}
    if team
      team
    else
      Team.new(team_hash)
    end
  end

  def self.all_teams_menu
    while true
      team_options = self.all.map{|team| team.full_team_name} + ["Back", "Exit"]
      show_options(ALL_TEAMS_TEXTS, team_options)
      selection = get_input(team_options)
      break if go_to_selection(selection, team_options) == "break"
    end
    
  end

  def self.teams_by_conference_menu
    puts "TODO"
  end

  def self.teams_by_division_menu
    puts "TODO"
  end

  def self.show_options(texts, options)
    texts.each{|text| puts text}
    options.each_with_index{|option, index| puts "#{index + 1}. #{option}"}
  end

  def self.get_input(options)
    input = gets.chomp.downcase
    while select_valid_option(input, options) == nil
      puts "invalid"
      input = gets.chomp.downcase
    end
    select_valid_option(input, options)
  end

  def self.go_to_selection(selection, options)
    case selection
    when options.length - 1
      CLI.exit_program
    when options.length - 2
      "break"
    else
      all.find{|team| team.full_team_name == options[selection]}.team_details
    end
  end

  def self.select_valid_option(input, options)
    if input.to_i < 1
      options.find_index{|option| input == option.downcase}
    elsif options[input.to_i - 1]
      input.to_i - 1
    else
      nil
    end
  end

  def team_details
    puts "***************************************"
    puts "Team Name: #{full_team_name}"
    puts "Abbreviation: #{@abbreviation}"
    puts "Conference: #{@conference}"
    puts "Division: #{@division}"
    puts "Arena: #{@venue}"
    puts "First Year of Play: #{@first_year_of_play}"
    puts "Website: #{@website}"
    puts "***************************************"
    menu
  end

  def menu
    while true
      options = ["Show Roster", "Back", "Exit"]
      show_options(["Please select an option:"], options)
      selection = get_input(options)
      break if go_to_selection(selection, options) == "break"
    end
  end

  def go_to_selection(selection, options)
    case selection
    when options.length - 1
      CLI.exit_program
    when options.length - 2
      "break"
    when 0
      show_roster
    end
  end

  def show_options(texts, options)
    texts.each{|text| puts text}
    options.each_with_index{|option, index| puts "#{index + 1}. #{option}"}
  end

  def get_input(options)
    input = gets.chomp.downcase
    while self.class.select_valid_option(input, options) == nil
      puts "invalid"
      input = gets.chomp.downcase
    end
    self.class.select_valid_option(input, options)
  end

  def show_roster
    if !@fetched_players
      Fetcher.fetch_players(self)
    end
    Player.players_by_team(self)
  end

  def full_team_name
    "#{@city} #{@name}"
  end

  def self.all
    @@all
  end

end