require 'net/http'
require 'json'

class GamesController < ApplicationController
  def new
    alphab = ('a'..'z').to_a
    @letters = alphab.sample(10)
    session[:letters] = @letters
  end

  def score
  @word = params[:word].downcase
  @letters = session[:letters]

    if included?(@word, @letters)
      url = URI("https://dictionary.lewagon.com/#{@word}")
      response = Net::HTTP.get(url)
      parsed_response = JSON.parse(response)

      if parsed_response["found"] == true
        @message = "Congratulations! #{@word.upcase} is a valid English word."
        @score = @word.length
      else
        @message = "Sorry, but #{@word.upcase} does not seem to be a valid English word."
        @score = 0
      end
    else
      @message = "Sorry, but #{@word.upcase} can't be built out of #{@letters.join(', ').upcase}."
      @score = 0
    end
  end


  private

  def included?(word, letters)
    word.chars.all? { |letter| word.count(letter) <= letters.count(letter) }
  end
end
