require 'faker'

def setup
    # attempts allowed before game over
    attempts_left = nil
    # empty array to store guesses
    letters_used = []
    # secret_word letters replaced by "_"
    progress = []
    
    # secret_word = “random_word_from_faker_gem”
    secret_word = Faker::Address.country

    # secret_word letters replaced by "_"
    secret_word.each_char {|c| 
        if c != " " then 
            progress.push("_")
        else
            progress.push(" ") 
        end
    }

    p progress.join(" ")
end

setup