class Teams_Menu < Menu

  def initialize(teams, div_conf = nil)
    @options = teams.map{|team| team.full_team_name} + ["Back", "Exit"]
    @teams = teams
    while true
      puts "\nTeams" + (div_conf == nil ? ":\n" : " in #{div_conf}:\n\n")
      show_options(@options)
      puts "\nSelect Team Name or Index for more information, or 'Back' / 'Exit'\n\n"

      selection = nil
      while selection == nil
        selection = is_valid?(get_input, @options)
      end
      break if go_to_selection(selection) == "break"
    end
  end

  def go_to_selection(selection)
    case selection
    when @options.length - 1
      CLI.exit_program
    when @options.length - 2
      "break"
    else
      Team_Menu.new(@teams[selection])
    end
  end

end



