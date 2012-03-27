class Movie < ActiveRecord::Base
  def self.all_ratings
    #find all records, then map rating attributes to an array
    find(:all, :select => "DISTINCT(rating)").map(&:rating)
  end
  def self.find_with_ratings(ratings)
    if defined? ratings == nil 
      find(:all)
    elsif ratings.length == 0
      find(:all, :select => "where rating='G'")
    else
      find(:all)
    end
  end
end
