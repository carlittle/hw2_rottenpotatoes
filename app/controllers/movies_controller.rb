class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    if params[:sortby]
      if params[:sortby][/^title/]=="title"
        session[:sortby]="title ASC"
      elsif params[:sortby][/^release_date/]=="release_date"
        session[:sortby]="release_date ASC"
      elsif params[:sortby][/^title/]=="title" && (!session[:sortby]==nil || session[:sortby][/^title/] != "title")
        session[:sortby]="title ASC"
      elsif params[:sortby][/^release_date/]=="release_date" && (!session[:sortby]==nil || session[:sortby][/^release_date/] != "release_date")
        session[:sortby]="release_date ASC"
      else
        session[:sortby] = nil
      end
    end
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
    if params[:sortby]
      session[:sortby]=params[:sortby]
    end

    if params[:ratings]
      session[:ratings] = params[:ratings]
    end

    newparams = ""
    if session[:sortby]
      newparams += "sortby=#{session[:sortby]}"
    end
    session[:ratings].each do |key, value|
      if newparams.length == 0
        newparams += "#{key}=#{value}"
      else
        newparams += "&#{key}=#{value}"
      end
    end
    redirect_to movies_path("", :ratings => session[:ratings], :sortby => session[:sortby])
  end

  def sortby
    if params[:sortby]=="title"
      session[:sortby]="title"
      @highlight="title"
    elsif params[:sortby]=="release_date"
      session[:sortby]="release_date"
      @highlight="release"
    else
      session[:sortby]=nil
    end
      redirect_to movies_path + "/#{session[:sortby]}"
  end

  def sort_by_title
    if session[:sortby]=="title ASC"
      session[:sortby]="title DESC"
    else
      session[:sortby]="title ASC"
    end
    if params[:commit]
      session[:ratings]=params[:ratings]
    end
    @highlight="title"
    redirect_to movies_path + "/title"
  end

  def sort_by_release
    if session[:sortby]=="release_date ASC"
      session[:sortby]="release_date DESC"
    else
      session[:sortby]="release_date ASC"
    end
    if params[:commit]
      session[:ratings]=params[:ratings]
    end
    @highlight="release"
    redirect_to movies_path + "/sort"
  end

  def titleasc
    session[:sortby]='title'

    if params[:ratings]
      session[:ratings] = params[:ratings]
    end

    newparams = ""
    if session[:sortby]
      newparams += "sortby=#{session[:sortby]}"
    end
    session[:ratings].each do |key, value|
      if newparams.length == 0
        newparams += "#{key}=#{value}"
      else
        newparams += "&#{key}=#{value}"
      end
    end
    redirect_to movies_path("", :ratings => session[:ratings], :sortby => session[:sortby])
  end

  def title
    session[:sortby]="title"
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
    render "index"
  end

  def titledesc
    @all_ratings = Movie.all_ratings
    session[:sortby]="title DESC"
    if params[:commit]
      session[:ratings]=params[:ratings]
    end
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
    @movies = Movie.order(session[:sortby])
    @highlight="title"
    render "index"
  end

  def release_dateasc
    session[:sortby]='release_date'

    if params[:ratings]
      session[:ratings] = params[:ratings]
    end

    newparams = ""
    if session[:sortby]
      newparams += "sortby=#{session[:sortby]}"
    end
    session[:ratings].each do |key, value|
      if newparams.length == 0
        newparams += "#{key}=#{value}"
      else
        newparams += "&#{key}=#{value}"
      end
    end
    redirect_to movies_path("", :ratings => session[:ratings], :sortby => session[:sortby])
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
