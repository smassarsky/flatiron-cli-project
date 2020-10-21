class Players_List_Menu < Menu

  def initialize(players_list, team=nil)
    @players_list = players_list.sort_by{|player| player.position_abbreviation}
    @options = @players_list.map{|player| "#{player.full_name} - #{player.position_abbreviation} - #{player.jersey_number}"} + ["Back", "Exit"]

    while true
      puts "\n#{team.full_team_name} roster:\n\n" if team != nil
      puts "   Player - Position - Jersey Number"
      show_options(@options)
      puts "\nSelect Player Name or Index for more information, or 'Back' / 'Exit'"

      selection = nil
      while selection == nil
        selection = is_valid?(get_input, @players_list.map{|player |player.full_name} + ["Back", "Exit"])
      end
      break if go_to_selection(selection) == "break"

    end
  end
  def go_to_selection(selection)
    if selection == @options.length - 1
      CLI.exit_program
    elsif selection == @options.length - 2
      "break"
    else
      Player_Menu.new(@players_list[selection])
    end
  end

end