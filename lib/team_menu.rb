class Team_Menu < Menu

  def initialize(team)
    @team = team
    @options = ["Show Roster", "Back", "Exit"]
    while true
      team.team_details
      show_options(@options)
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
    when 0
      @team.show_roster
    end
  end

end