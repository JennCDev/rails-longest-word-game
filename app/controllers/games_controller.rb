require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = []
    10.times do
      @letters << ("A".."Z").to_a.sample
    end
    unless session[:score]
      session[:score] = 0
    end
  end

  def score
    @word = params[:word]
    @letters = params[:letters].split
    url = "https://wagon-dictionary.herokuapp.com/#{@word}"
    word_serialized = URI.open(url).read
    word = JSON.parse(word_serialized)
    if !(@letters.permutation(@word.size).to_a.include?(@word.upcase.chars))
      @message = "Sorry but #{@word} can't be built of #{@letters.join(", ")}"
    elsif !word["found"]
      @message = "Sorry but #{@word} does not seem to be a valid English word..."
    else
      @message = "Congratulations! #{@word} is a valid English word!"
      session[:score] += @word.size**2
    end
    @score = session[:score]
  end
end
