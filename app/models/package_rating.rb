class PackageRating < ActiveRecord::Base

  attr_accessible :user, :package, :rating, :aspect

  belongs_to :user, :touch => true
  belongs_to :package, :touch => true

  fires :new_package_rating, :on                => [:create, :update],
                             :actor             => :user,
                             :secondary_subject => :package

  validates_existence_of :package_id
  validates_existence_of :user_id

  # users can only have one active vote per package:
  validates_uniqueness_of :user_id, :scope => [:package_id, :aspect]
  validates_format_of :rating, :with => /^[1-5]$/
  validates_inclusion_of :aspect, :in => %w(overall documentation)

  after_create lambda { |obj| obj.package.update_score! }
  after_update lambda { |obj| obj.package.update_score! }

  # Calculates the average rating for a given package
  def self.calculate_average(package_id, aspect=nil)
    if aspect
      self.average('rating',
                   :conditions => ["aspect = ? AND package_id = ?",
                                   aspect, package_id]).to_f
    else # combined overall+documentation
      self.average('rating',
                   :conditions => ["package_id = ?",
                                   package_id]).to_f
    end
  end

  def to_s
    rating.to_s
  end

end
