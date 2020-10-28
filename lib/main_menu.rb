class Main_Menu < Menu

  OPTIONS = ["All Teams",
             "Teams by Conference",
             "Teams by Division",
             "Players by Team",
             "All Players",
             "Exit"]

  def initialize
    while true
      intro_text
      selection = show_options_and_get_valid_input(OPTIONS)
      go_to_selection(selection)
    end
  end

  def intro_text
    puts "\nWhat would you like to view?\n\n"
  end

  def go_to_selection(selection)
    case selection
    when 0
      go_to_all_teams
    when 1
      go_to_teams_by_conference
    when 2
      go_to_teams_by_division
    when 3
      go_to_team_roster
    when 4
      go_to_all_players
    when 5
      CLI.exit_program
    end
  end

  def go_to_all_teams
    Teams_Menu.new(Team.all)
  end

  def go_to_teams_by_conference
    puts "\nConferences:\n\n"
    options = Team.conferences << "Back"
    conference_selection = show_options_and_get_valid_input(options)
    conference = Team.conferences[conference_selection]
    Teams_Menu.new(Team.teams_in_conference(conference), "#{conference} Conference") if conference_selection != Team.conferences.length
  end

  def go_to_teams_by_division
    puts "\nDivisions:\n\n"
    options = Team.divisions << "Back"
    division_selection = show_options_and_get_valid_input(options)
    division = Team.divisions[division_selection]
    Teams_Menu.new(Team.teams_in_division(division), "#{division} Division") if division_selection != Team.divisions.length
  end

  def go_to_team_roster
    puts "\nPlease select a team to view their roster:\n\n"
    options = Team.all_team_names << "Back"
    team_selection = show_options_and_get_valid_input(options)
    Team.find_by_name(options[team_selection]).show_roster if team_selection != options.length - 1
  end

  def go_to_all_players
    puts "\nAre you sure?  This will take a while... ('y' or 'yes' to continue)\n\n"
    input = gets.chomp.downcase
    if input == 'y' || input == "yes"
      Team.check_all_fetched_players
      Players_List_Menu.new(Player.all)
    end
  end

end