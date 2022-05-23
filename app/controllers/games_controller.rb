require "open-uri"

class GamesController < ApplicationController
  def new
    @letters = []
    10.times do
      @letters << ('a'..'z').to_a.sample
    end
  end

  def is_english?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    attempt_serialized = URI.open(url).read
    attempt_parsed = JSON.parse(attempt_serialized)
    attempt_parsed['found']
  end

  def check_letter(word, grid)
    word = word.upcase
    word.chars.all? { |element| (grid.count(element) >= word.count(element)) }
  end

  def score
    attempt = params[:input]
    grid = @letters

    if is_english?(attempt) == false
      @message = "Sorry but #{attempt} does not seem to be a valid English word..."
    elsif check_letter(attempt.upcase, grid) == false
      @message = "Sorry but #{attempt} can't be built out of #{@letters}"
    else
      @message = "Congratulations! #{attempt} is a valid English word!"
    end
  end
end
