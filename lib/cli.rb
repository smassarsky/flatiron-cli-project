class CLI

  attr_reader :fetcher

  OPTIONS = ["All Teams",
             "Teams by Conference",
             "Teams by Division",
             "Players by Team",
             "All Players",
             "Exit"]

  def initialize
    Fetcher.fetch_teams
    while true
      show_options
      go_to_selection(get_input)
    end
  end

  def get_input
    input = gets.chomp.downcase
    while select_valid_option(input) == nil
      puts "invalid"
      input = gets.chomp.downcase
    end
    input = select_valid_option(input)
  end

  def select_valid_option(input)
    if input.to_i < 1
      OPTIONS.find_index{|option| input == option.downcase}
    elsif OPTIONS[input.to_i - 1]
      input.to_i - 1
    else
      nil
    end
  end

  def show_options
    puts "Welcome to the CLI NHL Team & Player stats application! (I'm great at names!)"
    puts "What would you like to view?"
    OPTIONS.each_with_index {|option, index| puts "#{index + 1}. #{option}"}
    nil
  end

  def go_to_selection(selection)
    case selection
    when 0
      puts "TODO - Go to all teams"
      Team.all_teams_menu
    when 1
      puts "TODO - Go to Teams by Conference"
      Team.team_by_conference_menu
    when 2
      puts "TODO - Go to Teams by Division"
      Team.team_by_division_menu
    when 3
      puts "TODO - Go to Players by Team"
    when 4
      puts "TODO - Go to All Players"
    when 5
      self.class.exit_program
    end
  end

  def self.exit_program
    puts "Thank you for visiting!!"
    exit
  end

end