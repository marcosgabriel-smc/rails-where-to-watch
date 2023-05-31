require "open-uri"
require "nokogiri"

class MoviesController < ApplicationController
  def home
  end

  def create
    redirect_to show_movie_path([params[:movie_name]])
  end

  def show
    find_movie(params[:movie_name])
    parse_movie(@movie_url)
    raise
  end

  private

  def find_movie(movie)
  url = "https://www.justwatch.com/br/busca?q=#{movie}"
  html_file = URI.open(url).read
  html_doc = Nokogiri::HTML.parse(html_file)
  nokogiri_object = html_doc.search(".title-list-row__column-header")[0]
  @movie_url = nokogiri_object["href"]
  # html_doc.search(".standard-card-new__article-title").each do |element|
  #   puts element.text.strip
  #   puts element.attribute("href").value
  end

  def parse_movie(movie_url)
    @array = []
    url = "https://www.justwatch.com#{movie_url}"
    html_file = URI.open(url).read
    html_doc = Nokogiri::HTML.parse(html_file)
    html_doc.search(".price-comparison__grid__row.price-comparison__grid__row--stream.price-comparison__grid__row--block.price-comparison__grid__row").each do |element|
      @array << element.text
    end
  end

end
