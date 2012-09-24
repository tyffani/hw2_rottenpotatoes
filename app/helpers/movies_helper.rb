module MoviesHelper
  # Checks if a number is odd:
  def oddness(count)
    count.odd? ?  "odd" :  "even"
  end

  def has_rating(rating)
    if (session.has_key?(:ratings))
      params[:ratings].include?(rating)
    end
  end
end
