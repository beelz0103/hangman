module GameSaver
  def save_game    
    dirname = "saved_games"
    file = file_name(dirname)
    Dir.mkdir(dirname) unless File.exists?dirname
    File.open("#{dirname}/#{file}.yaml", 'w'){|f| f.puts to_yaml} 
    puts "Saved game succesfully!"
  end

  def load_game
    dirname = "saved_games"
    file = get_load_file_name
    contents = File.open("#{dirname}/#{file}").readlines.join
    data = from_yaml(contents)
    puts "You loaded a saved game"
    assign_to_variables(data)
    print_all_text
    start_game
    conclusion
  end

  def to_yaml
    YAML.dump ({
      :solution => @solution,
      :hidden_solution => @hidden_solution,
      :correct_guesses => @correct_guesses,
      :incorrect_guesses => @incorrect_guesses,
      :incorrect_guesses_left => @incorrect_guesses_left
    })
  end

  def from_yaml(string)
    YAML.load string
  end

  def file_name(dirname)
    puts "Input file name"
    file = gets.chomp
    if File.exists?("#{dirname}/#{file}.yaml")
      puts "File already exists, do you wish to overwrite it? Y/N"
      while true
        overwrite = gets.chomp     
        break if %w(Y N).include? overwrite
        puts "Please input Y to overwrite and N if you dont want to overwrite"
      end      
      overwrite == 'Y' ? file : file_name(dirname)
    else
      file
    end
  end

  def assign_to_variables(data)
    @solution = data[:solution]    
    @hidden_solution = data[:hidden_solution]
    @correct_guesses = data[:correct_guesses]
    @incorrect_guesses = data[:incorrect_guesses]
    @incorrect_guesses_left = data[:incorrect_guesses_left]
  end

  def get_load_file_name
    dirname = "saved_games"
    files = Dir.children(dirname) 
    puts "Input the number for the saved filed you wish to load:"
    files.each_with_index {|file, index| puts "#{index+1}. #{file}"}  
    while true
      file_number = gets.chomp      
      break if ("1".."#{files.count}").include? file_number 
      puts "Please input a valid number fore the saved file you wish to load"
      files.each_with_index {|file, index| puts "#{index+1}. #{file}"}  
    end
    file_number = file_number.to_i - 1
    files[file_number]
  end
end