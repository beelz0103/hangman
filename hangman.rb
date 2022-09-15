# frozen_string_literal: true

# Game class where hangman stuff happens
class Game
  include Helper
  include GameSaver

  def initialize
    @incorrect_guesses = []
    @correct_guesses = []
    @incorrect_guesses_left = 8
  end

  def play
    while true
      puts game_start_text
      game_select = gets.chomp
      p game_select
      break if %w(1 2).include? game_select

      puts wrong_input
    end
    game_select == '1' ? new_game : load_game
  end

  def new_game
    @solution = choose_word.split('')
    @hidden_solution = create_hidden_solution(@solution)
    print_all_text
    start_game
    conclusion
  end

  def start_game
    until @incorrect_guesses_left.zero?
      puts guess_instructions
      @guess = guess_check_all(make_guess)

      if @guess == 'save'
        save_game
        break
      end
      check_guesses
      print_all_text
      break if game_over?
    end
  end

  def conclusion 
    if @incorrect_guesses_left.zero?
      puts 'You lost'
    elsif game_over?
      puts 'You won'
    end
  end

  def game_over?
    !@hidden_solution.include?('_')
  end

  def update_hints
    @solution.each_with_index do |letter, position|
      @hidden_solution[position] = make_bold(letter) if letter == @guess
    end
  end

  def print_all_text
    print_text(@hidden_solution, 'Board: ')
    print_text(@incorrect_guesses.map(&:downcase), 'Incorrect guesses: ', "\u001b[31m")
    print_text(@correct_guesses.map(&:downcase), 'Correct guesses: ', "\u001b[32m")
    print_text([@incorrect_guesses_left], 'Remainding incorrect guesses: ')
  end
end
