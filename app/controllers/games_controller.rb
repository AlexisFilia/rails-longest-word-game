require 'json'
require 'open-uri'

class GamesController < ApplicationController

  def new
    @array = (0...8).map { randomLetter }
    console
    if !params[:total_score]
      @total_score = 0
    else
      @total_score = params[:total_score]
    end
  end

  def score
    @array = params[:grid].split('')
    if fromTheArray
      englishWord
      if @result["found"]
        upscore
        @score = "<strong>Congratulation!</strong> #{params[:word].upcase} is an English word."
      else
        @score = "Sorry but #{params[:word].upcase} doesn't seem to be an Englidsh word..."
      end
    else
      @score = "Sorry #{params[:word].upcase} can't be built out of #{@array.join(", ")}"
    end
  end

  private

  def randomLetter
    (65 + rand(26)).chr
  end

  def fromTheArray
    params[:word].upcase.split('').each { |letter|
      if @array.include?(letter)
        @array.delete_at(@array.index(letter))
      else
        return false
      end
    return true
    }
  end

  def englishWord
    url = "https://wagon-dictionary.herokuapp.com/#{params[:word]}"
    apianswer = open(url).read
    @result = JSON.parse(apianswer)
  end

  def upscore
    @total_score = params["total_score"].to_i + @result["length"]
  end
end
