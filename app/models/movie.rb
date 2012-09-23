class Movie < ActiveRecord::Base


  def all_ratings
    ratings_list = []
    Movies.each do |movie|
      if !ratings_list.include?(movie.rating)
        ratings_list << movie.rating
      end
    end
    return ratings_list
  end

end
