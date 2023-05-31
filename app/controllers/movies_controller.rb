class MoviesController < ApplicationController
  def home
  end

  def create
    redirect_to show_movie_path([params[:movie_name]])
  end

  def show
    raise
  end
end
