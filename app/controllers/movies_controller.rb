class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    if params[:commit]
      session[:ratings]=params[:ratings]
    end
    if session[:ratings]
      @movies = Movie.order(session[:sortby]).find(:all, :conditions => ["rating IN (?)", session[:ratings].keys])
      @checked_ratings = params[:ratings]
    else
      @movies = Movie.order(session[:sortby]).find(:all)
      @checked_ratings = Array.new
    end
  end

  def titleasc_old
    @all_ratings = Movie.all_ratings
    session[:sortby]="title ASC"
    session[:ratings]=params[:ratings]
    if params[:ratings]
      @movies = Movie.order(session[:sortby]).find(:all, :conditions => ["rating IN (?)", params[:ratings].keys])
      @checked_ratings = params[:ratings]
    else
      @movies = Movie.order(session[:sortby]).find(:all)
      @checked_ratings = Array.new
    end
    @highlight="title"
    render "index"
  end

  def titleasc
    session[:sortby]="title ASC"
    if params[:ratings]
      session[:ratings]=params[:ratings]
    end
    @highlight="title"
    redirect_to movies_path
  end

  def titledesc
    session[:sortby]="title DESC"
    if params[:ratings]
      session[:ratings]=params[:ratings]
    end
    @highlight="title"
    redirect_to movies_path
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
