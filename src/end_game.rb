# requires yes?, welcome (for username) and setup methods to test by itself

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
    
    setup
    # call get_user_guess
end 

end_game("win")
