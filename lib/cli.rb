class CLI

  OPTIONS = ["All Teams",
             "Teams by Conference",
             "Teams by Division",
             "Players by Team",
             "All Players",
             "Exit"]

  def initialize
    Fetcher.fetch_teams
    puts "\n\nWelcome to the CLI NHL Team & Player stats application! (I'm great at names!)\n\n"
    Main_Menu.new
  end

  def self.exit_program
    puts "\nThank you for visiting!!\n\n"
    exit
  end

end