class MoviesController < ApplicationController

  
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index #? can @ratings_to_show out of current functions
    @all_ratings = Movie.all_ratings
    ratingsPara = params[:ratings] || session[:ratings]
    @ratings_to_show = ratingsPara.nil? ? @all_ratings : ratingsPara.keys
    @sort_by = params[:sort_by] || session[:sort_by]  
    if (params[:ratings].nil?) && (params[:sort_by].nil?)
      @movies = Movie.all
      return
    elsif !(params[:ratings].nil?)
      if session[:ratings] != params[:ratings]
        session[:ratings] = params[:ratings]
        redirect_to movies_path(:ratings => @ratings_to_show, :sort_by => @sort_by)
      end
    elsif !(params[:sort_by].nil?)
      if !session[:sort_by].eql?(params[:sort_by]) 
        session[:sort_by] = params[:sort_by]
        redirect_to movies_path(:ratings => @ratings_to_show, :sort_by => @sort_by)
      end
    else
      if session[:ratings] != params[:ratings]
        session[:ratings] = params[:ratings]
        redirect_to movies_path(:ratings => @ratings_to_show, :sort_by => @sort_by)  
      end
      if !session[:sort_by].eql?(params[:sort_by]) 
        session[:sort_by] = params[:sort_by]
        redirect_to movies_path(:ratings => @ratings_to_show, :sort_by => @sort_by)
      end
    end
    @movies = Movie.with_ratings(@ratings_to_show, @sort_by)
   
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
