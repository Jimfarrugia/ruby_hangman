# ToDo(Add to trello board)
# - validate secret word
      # - must not include anything other than letters and spaces

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
  # secret_word letters replaced by "_"
  @progress = []
  # secret_word = “random_word_from_faker_gem”
  @secret_word = Faker::Address.country.upcase
  # secret_word letters replaced by "_"
  @secret_word.each_char {|c| 
      if c != " " then 
        @progress.push("_")
      else
        @progress.push(" ") 
      end
  }
  @progress = @progress.join(" ")
end

def get_user_guess
  p @secret_word # debugging
  puts "Guess a letter:  #{@progress}"
  guess = gets.strip.upcase
  # if guess doesn't match with any letter a-z or isn't a single character
  if guess !~ /[a-zA-Z]/ or guess.length != 1
    puts "Guess was invalid! Must be a single alphabetic character."
    return get_user_guess # restart the method
  end
  # if guess is already stored in letters_used
  if @letters_used.include?(guess)
    puts "You've already tried that letter..."
    return get_user_guess #restart the method
  end
  # guess has passed validation at this point

  @letters_used.push(guess)

  if @secret_word.include?(guess)
    progress = @progress.split.join
    i = 0
    while i < @secret_word.length - 1
      if @secret_word.chars[i] == guess
        progress[i] = @secret_word.chars[i]
      end
      i += 1
    end
    @progress = progress
    
  end
  p @progress
end

welcome

setup

get_user_guess

p "outside/after get_user_guess call"

#return username