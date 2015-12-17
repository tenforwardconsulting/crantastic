class Tag < ActiveRecord::Base

  attr_accessible :name

  # NOTE: Causes problems for PostgreSQL 8.3. Uncommented until fixed in Rails.
  # default_scope :order => "LOWER(name) ASC"
  scope :ordered, :order => "LOWER(name) ASC"
  scope :regular, :conditions => "type IS NULL"

  # Taggings should be destroyed together with the tag
  has_many :taggings, :dependent => :destroy
  has_many :packages, :through => :taggings

  validates_presence_of :name
  validates_uniqueness_of :name, :scope => :type
  validates_format_of :name, :with => /^[A-Za-z0-9\-]*[A-Za-z\d]$/
  validates_length_of :name, :in => 2..100

  ###
  # @param tags [String] A list of tags, separated by space (prefered) or commas
  # @return [Array] An array of Tag instances
  def self.parse_and_find_or_create(tags)
    # handles tags in quotes
    if tags =~ /^\".+\"$/
      tags = tags[1..-2].gsub(/ /, '-')
    end
    tags.split(/[, ]/).map(&:strip).reject(&:empty?).collect do |tag|
      self.find_or_create_with_like_by_name(tag)
    end
  end

  # Case insensitive. NOTE: Could be done more elegantly with Postgres' ~*
  # operator. The method name is inherited, consider renaming in the future.
  def self.find_or_create_with_like_by_name(name)
    find(:first, :conditions => ["LOWER(name) = LOWER(?) AND type IS NULL", name]) ||
      create!(:name => name)
  end

  def self.find_by_param(id)
    self.find_by_name!(id)
  end

  def ==(other)
    other.is_a?(Tag) && other.name == self.name
  end

  def to_s
    name
  end

  def to_param
    name
  end

  def task_view?
    self.kind_of?(TaskView)
  end

  # Returns true if this tag is a priority (base or recommended, extracted from CRAN)
  def priority?
    self.kind_of?(Priority)
  end

  # Tag weight for use in tag clouds.  Dividing by the number of letters
  # ensures that the area of the word is proportional to the number of
  # tagged objects, rather than just the height of the text.
  def weight
    count / name.length
  end

  ###
  # Returns the number of packages tagged with this tag.
  # NOTE: this could be cached later on
  #
  # @return [Fixnum]
  def count
    Tagging.count(:package_id, :conditions => "tag_id = #{self.id}")
  end
end
