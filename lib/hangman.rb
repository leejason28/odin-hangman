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
  end

  def play
    puts "Hello, welcome to Hangman."
  end

end

g = Game.new
p g.secret
p g.secret_array
p g.guess_array.join(" ")
g.play