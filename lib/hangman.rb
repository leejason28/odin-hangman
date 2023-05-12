require 'json'

class Game

  @@words = File.readlines('google-10000-english-no-swears.txt')
  @@secret_words = []
  @@words.each do |word|
    shortened = word.gsub("\n", "")
    if shortened.length>4 && shortened.length<13
      @@secret_words.push(shortened)
    end
  end

  attr_accessor :secret, :secret_array, :guess_array, :guesses, :user_guessed, :user_incorrect_guessed

  def self.secret_words
    @@secret_words
  end

  def initialize
    @secret = @@secret_words[Random.rand(@@secret_words.length)]
    @secret_array = @secret.split("")
    @guess_array = []
    for i in 0...@secret_array.length
      @guess_array.push("_")
    end
    @guesses = 6 #head,body,2arms,2legs
    @user_guessed = []
    @user_incorrect_guessed = []
  end

  def play
    puts "Hello, welcome to Hangman. Guess the secret word one letter at a time."
    puts "Correct guesses will give you hints on the secret word. You have a total of 6 incorrect guesses."
    while !self.game_over?
      puts @guess_array.join(" ")
      puts "Guess a letter. You have #{@guesses} incorrect guesses remaining."
      puts "You have incorrectly guessed: #{@user_incorrect_guessed}"
      user_input = gets
      user_guess = user_input.gsub("\n", "").downcase
      while !self.valid_guess?(user_guess)
        puts @guess_array.join(" ")
        user_input = gets
        user_guess = user_input.gsub("\n", "").downcase
      end
      @user_guessed.push(user_guess)
      @user_incorrect_guessed = @user_guessed.filter { |char| !@secret_array.include?(char) }
      if @secret_array.include?(user_guess)
        @guess_array.map!.with_index { |letter, index| @secret_array[index]==user_guess ? user_guess : letter }
      else
        @guesses -= 1
      end
    end
    if @guesses>0
      puts "Congrats! You win! The word was: #{@secret}"
    else
      puts "You lose. The word was #{@secret}"
    end
  end

  def valid_guess?(string)
    if string.length != 1
      puts "Invalid guess. Valid guesses are a single alphabet character. Try again." 
      puts "You have incorrectly guessed: #{@user_incorrect_guessed}"
      return false
    end
    if @user_guessed.include?(string)
      puts "Invalid guess. You cannot guess the same letter again. Try again."
      puts "You have incorrectly guessed: #{@user_incorrect_guessed}"
      return false
    else
      if string.ord>=97 && string.ord<=122
        return true
      elsif string.ord>=65 && string.ord<=90
        return true
      else
        puts "Invalid guess. Valid guesses are a single alphabet character. Try again." 
        puts "You have incorrectly guessed: #{@user_incorrect_guessed}"
        return false
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

  def to_json
    JSON.dump ({
      :secret => @secret,
      :secret_array => @secret_array,
      :guess_array => @guess_array,
      :guesses => @guesses,
      :user_guessed => @user_guessed,
      :user_incorrect_guessed => @user_incorrect_guessed
    })
  end

  def from_json(string)
    JSON.load string
  end

  def save(string)
    #write to new file with contents of json dump
    File.open("#{string}.json", 'w') do |file|
      file.puts self.to_json
    end
  end

  def load(string)
    #read specified file and update instance variables with info from json 
    #delete the file
    data = to_json
    File.open("#{string}.json", 'r') do |file|
      data = from_json(file)
    end
    File.delete("#{string}.json")
    @secret = data['secret']
    @secret_array = data['secret_array']
    @guess_array = data['guess_array']
    @guesses = data['guesses']
    @user_guessed = data['user_guessed']
    @user_incorrect_guessed = data['user_incorrect_guessed']
  end

end

g = Game.new
#File.open("#{g.secret}.json", 'w') do |file|
  #file.puts g.to_json
#end
#gd = 'apple'
#File.open("#{g.secret}.json", 'r') do |file|
  #gd = g.from_json(file)
#end
#p gd
#File.delete("#{g.secret}.json")
g.play