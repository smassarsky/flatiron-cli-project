class Menu

  def show_options(options)
    options.each_with_index{|option, index| puts "#{index + 1}. #{option}"}
    puts ""
  end

  def get_input
    while true
      input = gets.chomp.downcase
      if input != "" && input != nil
        return input
      end
    end
  end

  def is_valid?(input, options)
    if input.to_i < 1
      temp = options.find_index{|option| input == option.downcase}
      puts "Invalid Input" if temp == nil
      temp
    elsif options[input.to_i - 1]
      input.to_i - 1
    else
      puts "Invalid Input"
    end
  end

  def get_valid_input(options)
    selection = nil
    while selection == nil
      selection = is_valid?(get_input, options)
    end
    puts ""
    selection
  end

  def show_options_and_get_valid_input(options)
    show_options(options)
    get_valid_input(options)
  end

  def display_extended_stats?(stats_hash)
    puts "\nDisplay extended stats? ('y' or 'yes')"
    input = get_input
    if input == "y" || input == "yes"
      Stats_Printer.extended_season_stats(stats_hash)
      any_input_to_go_back
    end
  end

  def get_valid_season
    while true
      puts "Please input a season (example format '20192020'):\n\n"
      input = get_input
      if input.length == 8 && input.to_i > 0
        break
      else
        puts "\nInvalid Season\n\n"
        return nil if try_again_or_go_back == 1
      end
    end
    input
  end

  def try_again_or_go_back
    show_options(["Try Again", "Back"])
    is_valid?(get_input, ["Try Again", "Back"])
  end

  def any_input_to_go_back
    puts "\nAny input to go back."
    gets
  end

end