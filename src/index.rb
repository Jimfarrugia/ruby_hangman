require 'faker'
require 'colorize'

@secret_word = nil 
@attempts_left = nil
@letters_used = nil
@progress = nil
@username = nil
#@secret_word_set = false
# we don't really need this variable because when @secret_word == nil, it evaluates to false.
# and when @secret_word == "any non-blank string", it evaluates to true.

# Determine weather response is 'like yes'(=>true) or 'like no'(=>false) or neither(=>try again)
def yes? response
  case response
    when "y", "Y", "yes", "Yes", "YES"
      return true
    when "n", "N", "no", "No", "NO"
      return false
    else
      puts "Please enter yes or no:"
      yes?(gets.chomp)
    end
end

# Welcome the user, present the rules / guide to the game, set a username
def welcome
  welcome_message  = "Welcome to Hangman!\n\n"
  welcome_message += "How to play:\n"
  welcome_message += "* Try to find the secret word by guessing one letter at a time.\n"
  welcome_message += "* Each correct guess will reveal those letters in the secret word.\n"
  welcome_message += "* Guess incorrectly and lose a life.\n"
  welcome_message += "* If you lose all 7 lives - game over!\n"

  puts welcome_message

  puts "Ready to play? (Y/N)"

  if not yes?(gets.chomp)
    puts "Okay. See you next time!\n"
    exit
  end

  puts "Enter a username:"
  @username = gets.chomp
  if @username.strip == "" then @username = "Player" end
end

# setup the game by assigning value to instance variables to be used throughout
def setup
  # attempts allowed before game over
  @attempts_left = 7
  # empty array to store guesses
  @letters_used = []
  # progress will be the secret_word letters replaced with "_"
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
  
  # secret_word letters replaced by "_"
  @secret_word.each_char {|c| 
      # if char is not a space
      if c != " " then 
        # append an underscore to progress
        @progress.push("_")
      else
        # append a space
        @progress.push(" ") 
      end
  }
  #joining progress array with spaces for legibility
  @progress = @progress.join(" ")
end

# display end_game result
def end_game(result)
  if result == "win"
    puts "The word was #{@secret_word}.".colorize(:green)
    victory_screen = "Congratulations – You’re on track to having better vocabulary :)\n"
    puts victory_screen.colorize(:green)
  end
  if result == "loss"
    game_over_screen = "Game Over – Better luck next time :(\n"
    puts "The word was #{@secret_word}.\n".colorize(:red)
    puts game_over_screen.colorize(:red)
  end
  
  puts "Play again? (Y/N)"
  
  if not yes?(gets.chomp)
    puts "Thanks for playing #{@username}. See you next time!\n"
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
    puts "Guess was invalid! Must be a single alphabetic character."
    puts "\n" # new line
    return get_user_guess # restart the method
  end
  # if guess is already stored in letters_used
  if @letters_used.include?(guess)
    puts "You've already tried that letter..."
    puts "So far, you've tried: #{@letters_used.join(', ')}"
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
    # @progress does not contain any underscores
    if !@progress.include?("_")
      end_game("win") # victory
    else
      puts "Good guess!".colorize(:green)
      puts "So far, you've tried: #{@letters_used.join(', ')}"
      puts "\n" # new line
      get_user_guess
    end
  else # guessed letter isn't found in @secret_word
    @attempts_left -= 1 # lose a life
    if @attempts_left < 1
      end_game("loss") # game over
    else
      puts "Bad luck!".colorize(:red)
      puts "So far, you've tried: #{@letters_used.join(', ')}" # identical to above, dry this out later
      puts "You have #{@attempts_left} lives left."
      puts "\n" # new line
      get_user_guess
    end
  end

end

welcome

setup

puts "\nGood luck, #{@username}!"
puts "The word is the name of a country."
puts "The word contains #{@secret_word.length} letters."

get_user_guess # game loop

