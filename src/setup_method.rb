require 'faker'

# setup the game by assigning value to instance variables to be used throughout
def setup
    # attempts allowed before game over
    attempts_left = nil
    # empty array to store guesses
    letters_used = []
    # secret_word letters replaced by "_"
    progress = []
    
    # secret_word = “random_word_from_faker_gem”
    secret_word = Faker::Address.unique.country || Faker::Food.unique.fruits
    puts "#{secret_word}"

    # secret_word letters replaced by "_"
    secret_word.each_char {|c| 
        if c != " " then 
            progress.push("_")
        else
            progress.push(" ") 
        end
    }
    #joining progress array with spaces for legibility
    p progress.join(" ")
end

setup