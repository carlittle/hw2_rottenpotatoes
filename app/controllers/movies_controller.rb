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

  def ratings
    if params[:commit]
      session[:ratings]=params[:ratings]
    end
    redirect_to movies_path
  end

  def title
    if session[:sortby]=="title ASC"
      session[:sortby]="title DESC"
    else
      session[:sortby]="title ASC"
    end
    if params[:commit]
      session[:ratings]=params[:ratings]
    end
    @highlight="title"
    redirect_to movies_path
  end

  def release
    if session[:sortby]=="release_date ASC"
      session[:sortby]="release_date DESC"
    else
      session[:sortby]="release_date ASC"
    end
    if params[:commit]
      session[:ratings]=params[:ratings]
    end
    @highlight="release"
    redirect_to movies_path
  end

  def titleasc
    if session[:sortby]=="title ASC"
      session[:sortby]="title DESC"
    else
      session[:sortby]="title ASC"
    end
    if params[:commit]
      session[:ratings]=params[:ratings]
    end
    @highlight="title"
    redirect_to movies_path
  end

  def titledesc
    session[:sortby]="title DESC"
    if params[:commit]
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
