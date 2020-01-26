# class GamesController < ApplicationController
#   def new
#     @letters = generate_grid(10).join
#   end

#   def score
#     # Retrieve all game data from form
#     grid = params[:grid].split("")
#     @attempt = params[:attempt]
#     start_time = Time.parse(params[:start_time])
#     end_time = Time.now

#     # Compute score
#     @result = run_game(@attempt, grid, start_time, end_time)
#   end

#   private

#   def generate_grid(grid_size)
#   # TODO: generate random grid of letters
#     grid_size.times.map { ("a".."z").to_a.sample }
#   end

#   def api(attempt)
#     api_url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
#     serialized_attempt = open(api_url).read
#     JSON.parse(serialized_attempt)
#   end

#   def contains_attempt?(attempt, grid)
#     attempt_characters = attempt.upcase.chars
#     attempt_characters.all? { |letter| attempt_characters.count(letter) <= grid.count(letter) }
#     # attempt_characters.all? { |ch| grid.delete_at(grid.index(ch)) if grid.include? ch }
#   end

#   # def contains_attempt?(attempt, grid)
#   #   (attempt | grid).flat_map { |letter| [letter] * [attempt.count(letter), grid.count(letter)].min }
#   # end

#   def run_game(attempt, grid, start_time, end_time)
#     # TODO: runs the game and return detailed hash of result
#     # check if attempt is inside grid & it's an english word
#     result = { score: 0 }
#     if !api(attempt)["found"] # not an English word
#       result[:message] = "not an english word"
#     elsif contains_attempt?(attempt, grid) == false # is an English, but not in the grid
#       result[:message] = "not in the grid"
#     else
#       result[:time] = end_time - start_time
#       result[:message] = "well done"
#       result[:score] = attempt.length * 1.25 + 100 - (end_time - start_time).to_i
#     end
#     result
#   end
# end

require "open-uri"

class GamesController < ApplicationController
  VOWELS = %w(A E I O U Y)

  def new
    @letters = Array.new(5) { VOWELS.sample }
    @letters += Array.new(5) { (('A'..'Z').to_a - VOWELS).sample }
    @letters.shuffle!
  end

  def score
    @letters = params[:letters].split
    @word = (params[:word] || "").upcase
    @included = included?(@word, @letters)
    @english_word = english_word?(@word)
  end

  private

  def included?(word, letters)
    word.chars.all? { |letter| word.count(letter) <= letters.count(letter) }
  end

  def english_word?(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    json['found']
  end
end

