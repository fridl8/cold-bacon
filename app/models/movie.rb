class Movie < ApplicationRecord
  has_many :roles
  has_many :leading_actors, through: :roles, source: :actor
  has_many :paths, as: :traceable

  validates_presence_of :title, :image_url, :tmdb_id
  validates_uniqueness_of :title, :tmdb_id

  def get_top_billed_actors
    unless leading_actors.count == number_of_top_billed_actors
      get_full_movie_cast[0...number_of_top_billed_actors].each do |actor|
        actor = Actor.find_or_create_by(name: actor["name"], tmdb_id: actor["id"], image_url: actor["profile_path"])
        Role.find_or_create_by(actor: actor, movie: self)
      end
    end
    leading_actors
  end

  def get_full_movie_cast
    Tmdb::Movie.casts(tmdb_id)
  end

  def number_of_top_billed_actors
    8
  end
end
