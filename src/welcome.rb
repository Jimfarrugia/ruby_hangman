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
username = gets.chomp
if username.strip == "" then username = "Player" end

#return username