class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @checked_ratings = params[:ratings]
    @all_ratings = Movie.all_ratings
    @movies = Movie.find_with_ratings(params[:ratings])
  end

  def titleasc
    @movies = Movie.where("rating = ?", params[:ratings])
    @movies = Movie.order("title ASC")
    @highlight="title"
    render "index"
  end

  def titledesc
    @movies = Movie.order("title DESC")
    @highlight="title"
    render "index"
  end

  def releaseasc
    @movies = Movie.order("release_date ASC")
    @highlight="release"
    render "index"
  end

  def releasedesc
    @movies = Movie.order("release_date DESC")
    @highlight="release"
    render "index"
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
