class ReviewComment < ActiveRecord::Base

  belongs_to :user
  belongs_to :review

  validates_existence_of :user_id
  validates_existence_of :review_id

  validates_length_of :title, :in => 3..45
  validates_length_of :comment, :minimum => 3

end
