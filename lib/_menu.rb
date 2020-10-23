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

  def get_valid_season
    while true
      input = get_input
      if input.length == 8 && input.to_i > 0
        break
      end
    end
    input
  end

end