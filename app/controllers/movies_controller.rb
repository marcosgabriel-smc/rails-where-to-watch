require 'open-uri'
require 'nokogiri'

class MoviesController < ApplicationController

  def home
  end

  def create
    redirect_to show_movie_path([params[:movie_name]])
  end

  def show
    find_movie(params[:movie_name])
    movie_info(@movie_url)
  end

  private

  ## RUN ALL METHODS TO RETRIEVE INFO AND CREATE A PAIR ["STREAMING NAME", "ICON URL"]
  def movie_info(movie_url)
    streamings(movie_url)
    poster(movie_url)
    plot(movie_url)
    title(movie_url)
    rating(movie_url)
    @streamings = @names_streamings.zip(@icons)
  end

  ## INDIVIDUAL METHODS FOR FINDING A CARACTHERISTIC OF THE REQUESTED MOVIE/SERIES
  def title(movie_url)
    parse_movie_page(movie_url)
    @title = @html_doc.search('h1')[0].text.strip
  end

  def plot(movie_url)
    parse_movie_page(movie_url)
    @plot = @html_doc.search('.text-wrap-pre-line.mt-0')[0].text.strip
  end

  def rating(movie_url)
    parse_movie_page(movie_url)
    @rating = @html_doc.search('.jw-scoring-listing__rating a').last.text.strip
  end

  def streamings(movie_url)
    parse_movie_page(movie_url)
    movie_objects = @html_doc.search('.price-comparison__grid__row__icon')
    streamings = movie_objects.map do |obj|
      obj.to_h["title"]
    end
    icons = movie_objects.map do |obj|
      obj.to_h["data-src"]
    end
    @names_streamings = streamings.uniq
    @icons = icons.uniq
  end

  def poster(movie_url)
    parse_movie_page(movie_url)
    @poster = @html_doc.search('.picture-comp.title-poster__image img')[0].to_h['data-src']
  end

  ## CREATING A NOKOGIRI OBJECT FOR PARSING
  def find_movie(movie)
  url = "https://www.justwatch.com/br/busca?q=#{movie}"
  html_file = URI.open(url).read
  html_doc = Nokogiri::HTML.parse(html_file)
  nokogiri_object = html_doc.search('.title-list-row__column-header')[0]
  @movie_url = nokogiri_object['href']
  end

  def parse_movie_page(movie_url)
    @array = []
    url = "https://www.justwatch.com#{movie_url}"
    html_file = URI.open(url).read
    @html_doc = Nokogiri::HTML.parse(html_file)
  end
end
