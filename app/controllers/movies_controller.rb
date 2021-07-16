class MoviesController < ApplicationController

  
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index #? can @ratings_to_show out of current functions
    @ratings_to_show = []
    @id = nil
    @all_ratings = Movie.all_ratings 
    #current ratings from params, id from params, previous ratings, previous id
#  the current variable: used in view, represent the change just made
#  the session: store the action just made, can be used in view
#  the params: the change just request
#
#  case1: the params: ratings: nil, id: nil
#         case1.1 session: ratings: nil, id: nil                 
#         case1.2 session: ratings: not nil
#         case1.3 session: id: not nil
#         case1.4 session: both not nil
#          
#  case2: the params: ratings: nil
#          update session id
#          case2.1 session: ratings: nil
#          case2.2 session: ratings: not nil
#  
#  case3: the params: id: nil
#         update the session ratings
#         case3.1 session: id: nil
#         case3.2 seesion: id: not nil
#  
#  case4: the params: both not nil
#         update session both
#         
#         
#  call with_ratings
#  
#  
#  
    
    if !(params[:ratings].nil?)
      session[:ratings] = params[:ratings]
    end   
    if !(params[:id].nil?)
      session[:id] = params[:id]
    end
    if !(session[:ratings].nil?)
      @ratings_to_show = session[:ratings].keys
    end
    if !(session[:ratings].nil?)
      @id = session[:id]
    end
    @movies = Movie.with_ratings(@ratings_to_show, @id)
   
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
