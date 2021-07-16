class Movie < ActiveRecord::Base
  @@all_ratings =['G','PG','PG-13','R']
  
  def self.all_ratings
    @@all_ratings        #error happens: instance variable VS class variable
  end
  
  def self.with_ratings(ratings_list, order_given)
    if ratings_list.empty?
      Movie.all
    else
      moviesQualified = nil
      ratings_list.each do |rating|
        if order_given == nil
          if moviesQualified == nil
            moviesQualified = Movie.where("rating LIKE ?", "#{rating}")
          else
            moviesQualified += Movie.where("rating LIKE ?", "#{rating}")
          end
        else
          order_given = order_given.eql?('title_header') ? 'title' : 'release_date'
          if moviesQualified == nil
            moviesQualified = Movie.where("rating LIKE ?", "#{rating}").order(order_given)
          else
            moviesQualified += Movie.where("rating LIKE ?", "#{rating}").order(order_given)
          end
        end
      end
      moviesQualified
    end
  end
  
  
end
