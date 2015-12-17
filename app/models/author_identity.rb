# Join table for identifying user accounts with authors
class AuthorIdentity < ActiveRecord::Base

  belongs_to :author
  belongs_to :user

  # Only one user can be identified as each author:
  validates_uniqueness_of :author_id

end
