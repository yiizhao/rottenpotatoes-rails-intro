class Movie < ActiveRecord::Base
  @@all_ratings =['G','PG','PG-13','R']
  
  def self.all_ratings
    @@all_ratings        #error happens: instance variable VS class variable
  end
  
  def self.with_ratings(ratings_list, order_given)
    if ratings_list.empty? && order_given.nil?
      Movie.all
    elsif ratings_list.empty?
      order_given = order_given.eql?('title_header') ? 'title' : 'release_date'
      Movie.order(order_given)
    elsif order_given.nil?
      moviesQualified = nil
      ratings_list.each do |rating|
        if moviesQualified == nil
          moviesQualified = Movie.where("rating LIKE ?", "#{rating}")
        else
          moviesQualified += Movie.where("rating LIKE ?", "#{rating}")
        end
      end
      moviesQualified
    else
      moviesQualified = nil
      order_given = order_given.eql?('title_header') ? 'title' : 'release_date'
      ratings_list.each do |rating|   
        if moviesQualified == nil
          moviesQualified = Movie.where("rating LIKE ?", "#{rating}").order(order_given)
        else
          moviesQualified += Movie.where("rating LIKE ?", "#{rating}").order(order_given)
        end
      end
      moviesQualified
    end
  end
  
  
end
