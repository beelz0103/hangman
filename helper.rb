# frozen_string_literal: true

# Helper module
module Helper
  def choose_word
    File.readlines('dict.txt').select { |line| line.chomp.length.between?(5, 12) }.sample.chomp
  end

  def print_text(array, string = '', color = "\u001b[0m")
    print "#{color}#{string}\u001b[0m"
    array.each { |e| print "#{color}#{e} \u001b[0m"}
    puts
  end

  def guess_instructions
    "Try to #{make_bold('guess')} the letter or type #{make_bold('save')} if you wish to save the game"
  end

  def correct_guess_string
    text_color('You guessed right, YAY!', 'green')
  end

  def incorrect_guess_string
    text_color('Your guess was wrong...', 'red')
  end

  def make_bold(string)
    "\u001b[1m#{string}\u001b[0m"
  end

  def text_color(string, color)
    case color
    when 'red'
      "\u001b[31m#{string}\u001b[0m"
    when 'green'
      "\u001b[32m#{string}\u001b[0m"
    end
  end

  def game_start_text
    "Type #{make_bold('1')} to start a #{make_bold('new game')} and #{make_bold('2')} to load a #{make_bold('saved game')}"
  end

  def wrong_input(type = 1)
    case type
    when 1
      make_bold('Wrong input, please follow the instructions')
    when 2
      make_bold('Wrong input, please input a valid letter from the alphabet!!!')
    when 3
      make_bold('You have already guessed this letter, try a different one')
    end
  end

  def create_hidden_solution(solution)
    solution.map { '_' }
  end

  def correct_guess?
    @solution.include? @guess
  end

  def check_guesses
    if correct_guess?
      guess_checker(@correct_guesses, correct_guess_string)
      update_hints
    else
      guess_checker(@incorrect_guesses, incorrect_guess_string)
      @incorrect_guesses_left -= 1
    end
  end

  def guess_checker(array, string)
    puts string
    array << @guess
  end

  def make_guess
    while true
      guess = gets.chomp
      break if guess.length == 1 && guess.match?(/[A-za-z]/) || guess.downcase == 'save'

      puts wrong_input 2
      puts guess_instructions
    end
    guess.downcase
  end

  def array_include_guess?(array, guess)
    array.map(&:downcase).include? guess
  end

  def guess_check_all(guess)
    all_guesses = @correct_guesses + @incorrect_guesses
    if array_include_guess?(all_guesses, guess)
      puts wrong_input 3
      puts guess_instructions
      guess_check_all(make_guess)
    else
      guess
    end
  end
end
