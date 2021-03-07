require 'faker'
require 'colorize'

# Declare instance variables
@secret_word = nil
@attempts_allowed = 7
@attempts_left = nil
@letters_used = nil
@progress = nil
@username = nil

# Build path and read ascii txt file
def ascii_img file_name
  ascii_path = File.join(File.dirname(__FILE__), '..', 'ascii', file_name)
  img = File.read(ascii_path)
end

# Clear the terminal
def clear_terminal
  Gem.win_platform? ? (system "cls") : (system "clear")
end

# Determine whether response is 'like yes'(=>true) or 'like no'(=>false) or neither(=>try again)
def yes? response
  case response.downcase
    when "y", "yes"
      return true
    when "n", "no"
      return false
    else
      puts "Please enter yes or no:".colorize(:light_red)
      yes?(gets.chomp)
  end
end

# Welcome the user, present the rules / guide to the game, set a username
def welcome
  how_to_play  = "How to play:\n"
  how_to_play += "* Try to find the secret word by guessing one letter at a time.\n"
  how_to_play += "* Each correct guess will reveal those letters in the secret word.\n"
  how_to_play += "* Guess incorrectly and lose a life.\n"
  how_to_play += "* If you lose all 7 lives - game over!\n"

  clear_terminal
  
  # ASCII title
  puts ascii_img('title.txt').colorize(:green)

  puts how_to_play.colorize(:light_blue)

  puts "\nReady to play? (Y/N)".colorize(:green)

  if not yes?(gets.chomp)
    puts "\nOkay. See you next time!\n".colorize(:green)
    exit
  end

  clear_terminal

  puts "\nEnter a username:".colorize(:green)
  @username = gets.chomp
  if @username.strip == "" then @username = "Player" end
end

# setup the game by assigning value to instance variables to be used throughout
# display intro for new game
def setup
  @attempts_left = @attempts_allowed
  @letters_used = []
  @progress = []
  # check if @secret_word already has a non-false value (ie. has been set)
  if @secret_word
    # generate and assign it a new random word (country)
    @secret_word = Faker::Address.unique.country.upcase
  end
  # until secret_word matches this /regular expression/
  until @secret_word =~ /^[a-zA-Z]{4,12}$/ # 4-12 alphabetic characters
    # generate and assign it a random word (country)
    @secret_word = Faker::Address.unique.country.upcase
  end
  # Add an underscore to progress array for each char in secret_word
  @secret_word.each_char { |char| 
    @progress.push("_")
  }
  #join underscores progress array with spaces for legibility
  @progress = @progress.join(" ")
  # Intro to new game
  clear_terminal
  puts "\nGood luck, #{@username}!\n".colorize(:green)
  puts "The word is the name of a country.".colorize(:light_blue)
  puts "The word contains #{@secret_word.length} letters.\n".colorize(:light_blue)
end

# display end_game result
def end_game(result)
  if result == "win"
    puts ascii_img 'victory.txt'
    victory_screen  = "\nYou won!
                       \nThe word was #{@secret_word}.\n"
    puts victory_screen.colorize(:green)
  end
  if result == "loss"
    puts ascii_img 'game_over.txt'
    game_over_screen = "\nGame Over - You ran out of lives!
                        \nThe word was #{@secret_word}.\n"
    puts game_over_screen.colorize(:red)
  end
  
  puts "Play again? (Y/N)".colorize(:green)
  
  if not yes?(gets.chomp)
    puts "\nThanks for playing, #{@username}. See you next time!\n".colorize(:green)
    exit
  else
    setup #new game
    get_user_guess
  end
end

# 1. get and validate the user's input,
# 2. handle point calculation (add to progress or lose a life)
# 3. repeat 1 and 2 until win-condition is met (all secret_word letters guessed) 
#    or loss-condition is met (0 lives left).
def get_user_guess
  # p @secret_word # debugging cheat
  puts "Guess a letter:  #{@progress}"
  guess = gets.strip.upcase
  # if guess doesn't match with any letter a-z or isn't a single character
  if guess !~ /[a-zA-Z]/ or guess.length != 1
    clear_terminal
    if @attempts_left < @attempts_allowed
      puts ascii_img "#{@attempts_left}_lives_left.txt"
    end
    puts "\nGuess was invalid! Must be a single alphabetic character.".colorize(:light_red)
    # show letters_used if its not empty
    if @letters_used != []
      puts "So far, you've tried: #{@letters_used.join(', ')}".colorize(:light_blue)
    end
      puts "\n" # new line
    return get_user_guess # restart the method
  end
  # if guess is already stored in letters_used
  if @letters_used.include?(guess)
    clear_terminal
    if @attempts_left < @attempts_allowed
      puts ascii_img "#{@attempts_left}_lives_left.txt"
    end
    puts "\nYou've already tried that letter...".colorize(:light_red)
    puts "So far, you've tried: #{@letters_used.join(', ')}".colorize(:light_blue)
    puts "\n" # new line
    return get_user_guess #restart the method
  end
  # guess has passed validation at this point

  # append the letter / guess to letters_used 
  @letters_used.push(guess)

  # if the guessed letter is found in secret_word
  if @secret_word.include?(guess)
    @progress = @progress.split.join # remove all spaces from progress string (temporarily)
    i = 0 # iterator / counter
    while i < @secret_word.length # iterate/count once for each item in array
      if @secret_word.chars[i] == guess # if value at current index == guess
        @progress[i] = @secret_word.chars[i] # assign the value at current index to the item/underscore at said index in @progress
      end
      i += 1 # increment
    end
    # split then rejoin chars with spaces between
    @progress = @progress.chars.join("\s")

    clear_terminal

    # @progress does not contain any underscores
    if !@progress.include?("_")
      end_game("win") # victory
    else
      # if player has less than 7 lives, display ascii
      if @attempts_left < @attempts_allowed
        puts ascii_img "#{@attempts_left}_lives_left.txt"
      end
      puts "\nGood guess!".colorize(:green)
      puts "So far, you've tried: #{@letters_used.join(', ')}".colorize(:light_blue)
      puts "\n" # new line
      get_user_guess
    end
  else # guessed letter isn't found in @secret_word
    clear_terminal
    @attempts_left -= 1 # lose a life
    if @attempts_left < 1
      end_game("loss") # game over
    else
      puts ascii_img "#{@attempts_left}_lives_left.txt"
      puts "\nBad luck!".colorize(:red)
      puts "So far, you've tried: #{@letters_used.join(', ')}".colorize(:light_blue) # identical to above, dry this out later
      puts "You have #{@attempts_left} lives left.".colorize(:light_red)
      puts "\n" # new line
      get_user_guess
    end
  end
end # of get_user_guess

welcome

setup

get_user_guess # game loop

