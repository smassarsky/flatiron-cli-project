class CLI

  def initialize
    Fetcher.fetch_teams
    puts "\n\nWelcome to the CLI NHL Team & Player stats application!\n\n"
    Main_Menu.new
  end

  def self.exit_program
    puts "Thank you for visiting!!\n\n"
    exit
  end

end