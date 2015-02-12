require 'yaml'

class Hangman
	attr_accessor(:secret_word, :secret_array, :display_array, :used_array, :guess_count)

	def initialize(name)
		@name = name
		@used_array = []
		@guess_count = 10
		retrieve_random_word
		array_generate
		game_play
	end

	def retrieve_random_word
	array = []
	File.open("5desk.txt").each do |line|
		if line.strip.length.between?(5,12)
			array << line.strip.downcase
		end
	end	
	@secret_word = array[rand(array.length - 1)]
	end
	
	def array_generate
		@secret_array = @secret_word.split('')
		@display_array = secret_array.map do |x|
			x = "__"
		end
	end

	def display
		puts "Hangman"
		puts
		puts @display_array.join(" ")
		puts "Guesses: #{@guess_count}  Used Letters: #{@used_array.join(' ')}"
		puts
		puts "Submit 1 to save game"
		puts
	end

	def get_user_input
		puts "Guess a letter"
		@input = gets.chomp.downcase
	end

	def compare_input
		if @input == "1"
			save_game(@name)
		else
			@secret_array.each_with_index do |letter,index|
				if letter == @input
					@display_array[index] = @input
				end
			end
		end

		@guess_count -= 1 if !secret_array.include? @input

		used_array << @input

		puts @display_array.join(" ")
	end

	def game_play
		until @display_array == @secret_array
			display
			get_user_input
			compare_input
			if @guess_count == 0
				puts "You Lose!"
				puts @secret_word
				break
			end
		end
	end
end

def save_game(name)
	yaml = YAML::dump(name)
  	File.open("#{name}.yaml", "w+") do |game_file|
  		game_file.write(yaml)
  	end
end

def load_game(name)
  	game_file = File.open("#{name}.yaml", "r")
  	yaml = game_file.read
  	YAML::load(yaml)
end

puts "What would you like to do?"
puts "1. Start a new game"
puts "2. Load a previous game"
choice = gets.chomp.to_i
case choice
when 1
	puts "Name of this game?"
	name = gets.chomp.downcase
	Hangman.new(name)
when 2
	puts "What is the name of the game?"
	name = gets.chomp.downcase
	load_game(name)
end
