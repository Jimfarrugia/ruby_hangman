
@result = "win"
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

def end_game(result)
    if result == "win"
        victory_screen = "Congratulations – You’re on track to having better vocabulary :)\n"
        puts victory_screen
   
    elsif result == "loss"
        game_over_screen = "Game Over – Better luck next time :(\n"
        puts game_over_screen
    end
    
    puts "Play again? (Y/N)"
    
    if not yes?(gets.chomp)
        puts "Thanks for playing #{@username}. See you next time!\n"
        exit
    end
    
end 

end_game("win")
# setup
# get_user_guess
