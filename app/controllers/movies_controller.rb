class MoviesController < ApplicationController
  attr_accessor :hilite
  attr_accessor :field
  attr_accessor :all_ratings
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end
  
  def index
    @hilite = "hilite"
    @all_ratings = ['G','PG','PG-13','R','NC-17']
    if params.has_key?(:sort)
      @movies = Movie.order(params[:sort])
      @field = params[:sort]
    else
      @movies = Movie.all
    end
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

  def updates
    
  end
  
  def updatess
    updateVariables = params.require(:movie).permit(:existingTitle, :title, :rating, :release_date)
    @movie = Movie.find_by_title(updateVariables[:existingTitle])
    if @movie
      if updateVariables[:title] != ""
        @movie.update_attribute(:title, updateVariables[:title])
      end
      if updateVariables[:rating] != ""
        @movie.update_attribute(:rating, updateVariables[:rating])
      end
      if updateVariables[:release_date] != ""
        @movie.update_attribute(:release_date, updateVariables[:release_date])
      end
      redirect_to movie_path(@movie)
    else
      redirect_to movies_path
    end
  end

  def delete
  end
  
  def deletes
    deleteVariables = params.require(:movie).permit(:title, :rating)
    if deleteVariables[:title] != ""
      @movie = Movie.find_by_title(deleteVariables[:title])
      if @movie
        @movie.destroy
        flash[:notice] = "Movie '#{@movie.title}' deleted."
      end
    elsif deleteVariables[:rating] != ""
      movies = Movie.where(:rating => deleteVariables[:rating])
      movies.each do |toDelete|
        toDelete.destroy
      end
      flash[:notice] = "All movies rated '#{deleteVariables[:rating]}' were deleted."
    end
      redirect_to movies_path
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
