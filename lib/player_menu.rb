class Player_Menu < Menu

  def initialize(player)
    @options = ["Current Season Stats(TODO)", "Stats by Season(TODO)", "All Stats(TODO)", "Back", "Exit"]
    while true
      player.display_player_info
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
    when 0
      puts "TODO - Go to Current Season Stats"
    when 1
      puts "TODO - Go to Stats By Season Menu"
    when 2
      puts "TODO - Go to All Stats"
    when 3
      "break"
    when 4
      CLI.exit_program
    end
  end

end