class Scrape

  attr_accessor :title, :hotness, :rating, :director, :image_url, :genre, :release_date, :runtime, :synopsis, :failure

  def scrape_new_movie
    begin
      doc = Nokogiri::HTML(open("http://www.rottentomatoes.com/m/the_martian/?search=martian"))
      
      doc.css('script').remove
      self.title = doc.at("//h1[@itemprop = 'name']").text
      self.hotness = doc.at("//span[@itemprop = 'ratingValue']").text.to_i
      self.rating = doc.at("//td[@itemprop = 'contentRating']").text
      self.director = doc.at("//span[@itemprop = 'name']").text
      self.image_url = doc.at_css('#movie-image-section img')['src']
      self.genre = doc.at("//span[@itemprop = 'genre']").text      
      self.release_date = doc.at("//td[@itemprop = 'datePublished']").text.to_date
      self.runtime = doc.at("//time[@itemprop = 'duration']").text
      s = doc.css("#movieSynopsis").text

      if ! s.valid_encoding?
        s = s.encode("UTF-16be", :invalid => :replace, :replace => "?").encode('UTF-8')
      end
      return true
    rescue Exception => e
      self.failure = "Somthing went wrong with the scrape"
    end
  end


  def save_movie
    movie = Movie.new(
      title: self.title,
      hotness: self.hotness,
      rating: self.rating,
      director: self.director,
      image_url: self.image_url,
      genre: self.genre,
      release_date: self.release_date,
      runtime: self.runtime,
      synopsis: self.synopsis
      )
    movie.save
  end

end