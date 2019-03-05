require 'faker'

@secret_word = nil
@attempts_left = nil
@letters_used = nil
@progress = nil
@username = nil

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

def setup
  # attempts allowed before game over
  @attempts_left = 7
  # empty array to store guesses
  @letters_used = []
  # progress will be the secret_word letters replaced with "_"
  @progress = []
  # until secret_word matches this /regular expression/
  until @secret_word =~ /^[a-zA-Z]{4,12}$/ # 4-12 alphabetic characters
    # generate random word (country)
    @secret_word = Faker::Address.country.upcase
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
  @progress = @progress.join(" ")
end

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
      # end_game("win")
      puts "You won the game! Congratulations!"# debugging / testing
      puts "The word was #{@secret_word}."
    else
      puts "Good guess!"
      puts "So far, you've tried: #{@letters_used.join(', ')}"
      puts "\n" # new line
      get_user_guess
    end
  else # guessed letter isn't found in @secret_word
    @attempts_left -= 1 # lose a life
    if @attempts_left < 1
      #end_game("loss")
      puts "Game Over!  You ran out of lives!"# debugging / testing
      puts "The word was #{@secret_word}."
    else
      puts "Bad luck!"
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
puts "The word contains #{@secret_word.length} letters." # @secret_word.length returns an 'undefined method' error. But I've used methods like .join in some of the string interpolation above.  Why doesn't it work here?  Maybe clean this up later. (redundant variable)


get_user_guess
