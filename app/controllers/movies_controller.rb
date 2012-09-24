class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end
  def index
    @all_ratings = Movie.all_ratings()
    """
    redirect = false
    if ratings
      session[:ratings] = params[:ratings]
    elsif params[:commit] == 'Refresh' || !ratings
      params[:ratings] = @all_ratings
    else
      params[:ratings] = session[:ratings]
      if !session[:ratings].nil?
        redirect = true
      end
    end
    if sort
      session[:sort] = params[:sort]
    else
      params[:sort] = session[:sort]
      redirect = true
    end

    if redirect
      redirect_to movies_path(params)
    end
  
    #raise params[:ratings].inspect THIS IS GIVING ME ARRAY
    #raise session[:ratings].inspect  THIS IS GIVING ME HASH
    if params[:ratings].class == 'Array'
      @movies = Movie.find_all_by_rating(session[:ratings])
    else
      raise params[:ratings].inspect 
      @movies = Movie.find_all_by_rating(session[:ratings].keys())
    end
#:order => params[:sorted], :conditions => ['rating IN (?)', params[:ratings]])
    """
    if !params && !session[:params]
      p = {:sort => @all_ratings, :ratings => nil}
      session[:params] = p
      redirect_to movies_path(session[:params])
    end
    if params.length == 2 && session[:params]
      flash.keep
      p = session[:params]
      params[:sort] = p[:sort]
      params[:ratings] = p[:ratings]
    elsif !params && session[:params]
      redirect_to movies_path(session[:params])
    end

    sort = params[:sort] 
    param_rating = params[:ratings]
    if param_rating
      ratings = param_rating.keys()
    end   
    if !ratings
      @ratings = @all_ratings
    else
      @ratings = ratings
    end

    session[:params] = params
    if sort == 'title'
      @title_header = 'hilite'
      if ratings
        @movies = Movie.find_all_by_rating(ratings).sort_by { |m| m.title}
      else
        @movies = Movie.all.sort_by {|m| m.title}
      end
    elsif sort == 'release_date_header'
      @release_date_header = 'hilite'
      if ratings
        @movies = Movie.find_all_by_rating(ratings).sort_by {|m| m.release_date}
      else
        @movies = Movie.all.sort_by { |m| m.title}
      end
    else
      if ratings
        @movies = Movie.find_all_by_rating(ratings)
      else
        @movies = Movie.all
      end
    end
    """
    if sort == 'title'
      session[:sorted] = params[:sorted]
      @title_header = 'hilite'
      if ratings
        session[:ratings] = params[:ratings]
        @movies = Movie.find_all_by_rating(params[:ratings]).sort_by { |m| m.title}
      elsif params[:commit] == 'Refresh' || !ratings
        params[:ratings] = @all_ratings
        @movies = Movie.all.sort_by {|m| m.title}
      else
        params[:ratings] = session[:ratings]
        if ratings
          redirect_to movies_path(params)
        end
      end
    elsif sort == 'release_date_header'
      session[:sorted] = params[:sorted]
      @release_date_header = 'hilite'
      if ratings
        session[:ratings] = params[:ratings]
        @movies = Movie.find_all_by_rating(params[:ratings]).sort_by {|m| m.release_date}
      elsif params[:commit] == 'Refresh' || !ratings
        params[:ratings] = @all_ratings
        @movies = Movie.all.sort_by {|m| m.release_date}
      else
        params[:ratings] = session[:ratings]
        if ratings
          redirect_to movies_path(params)
        end
      end
    else
      params[:sorted] = session[:sorted]
      redirect_to movies_path(params)
      if ratings
        session[:ratings] = params[:ratings]
        @movies = Movie.find_all_by_rating(params[:ratings])
      elsif params[:commit] == 'Refresh' || !ratings
        params[:ratings] = @all_ratings
        @movies = Movie.find_all_by_rating(params[:ratings])
      else
        if ratings
          redirect_to movies_path(params)
        end
      end
    end
    """
  end
  
  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
