class CLI

  attr_reader :fetcher

  def initialize
    make_fetcher
    fetch_teams
    menu_input_loop
    binding.pry
    puts "Thank you for visiting!"
  end

  def make_fetcher
    @fetcher = Fetcher.new
  end

  def fetch_teams
    @fetcher.fetch_teams
  end

  def menu_input_loop
    input = nil
    while input != "exit"
      show_teams_menu
      input = gets.chomp
      if input.to_i != 0
        index = input.to_i
        index > 0 && index <= Team.all.length ? Team.all[index - 1] : "Invalid"
        binding.pry
      else
        Team.all.find{|team| team.full_team_name.downcase == input.downcase}
        binding.pry
      end
    end
  end

  def show_teams_menu
    puts "Welcome to the CLI NHL Team & Player stats application! (I'm great at names!)"
    puts "Please pick a team from the following list(index or name):"
    Team.all.each_with_index{|team, index| puts "#{index + 1}. #{team.full_team_name}"}
    nil
  end

  # def pick_team
  #   input = nil
  #   until input == "exit" || Team.all.find(|team| team.full_team_name.downcase == input) ||
  # end

end