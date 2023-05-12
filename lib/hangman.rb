class Game

  @@words = File.readlines('google-10000-english-no-swears.txt')
  @@secret_words = []
  @@words.each do |word|
    shortened = word.gsub("\n", "")
    if shortened.length>4 && shortened.length<13
      @@secret_words.push(shortened)
    end
  end

  attr_accessor :secret, :secret_array, :guess_array

  def initialize
    @secret = @@secret_words[Random.rand(@@secret_words.length)]
    @secret_array = @secret.split("")
    @guess_array = []
    for i in 0...@secret_array.length
      @guess_array.push("_")
    end
    @guesses = 6 #head,body,2arms,2legs
  end

  def play
    puts "Hello, welcome to Hangman. Guess the secret word one letter at a time."
    puts "Correct guesses will give you hints on the secret word. You have a total of 6 incorrect guesses."
    while !self.game_over?
      puts @guess_array.join(" ")
      puts "Guess a letter. You have #{@guesses} incorrect guesses remaining."
      user_input = gets
      user_guess = user_input.gsub("\n", "")
      if @secret_array.include?(user_guess)
        @guess_array.map!.with_index { |letter, index| @secret_array[index]==user_guess ? user_guess : letter }
      else
        @guesses -= 1
      end
    end
  end

  def game_over?
    if @secret == @guess_array.join("")
      return true
    elsif @guesses == 0
      return true
    else
      return false
    end
  end

end

g = Game.new
p g.secret
g.play