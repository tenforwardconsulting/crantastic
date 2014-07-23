class Author < ActiveRecord::Base

  attr_accessible :name, :email

  is_gravtastic # Enables the Gravtastic plugin for the Author model

  # Note that one user can have multiple author identities, but
  # an author should only have one user.
  has_one :author_identity, :dependent => :destroy
  has_one :user, :through => :author_identity

  # Version/package relations are determined by packages this author is
  # maintaining or has maintained in the past
  has_many :versions, :class_name => "Version",
                      :foreign_key => :maintainer_id,
                      :order => "LOWER(name) ASC, id DESC"

  has_many :packages, :finder_sql =>
    'SELECT DISTINCT package.* FROM package ' +
    'INNER JOIN version ON package.id = version.package_id ' +
    'WHERE (version.maintainer_id = #{id})', :uniq => true

  default_scope :order => "LOWER(name)"

  # TODO: remove the scoping on name when possible
  validates_uniqueness_of :email, :scope => :name,
                                  :case_sensitive => false, :allow_nil => true
  validates_uniqueness_of :name

  validates_length_of :name, :in => 2..255
  validates_length_of :email, :in => 0..255, :allow_nil => true

  def self.find_or_create(name = nil, email = nil)
    author = email.nil? ? nil : self.find_by_email(email)
    author = self.find_by_name(name) unless author
    author.nil? ? self.create(:name => name, :email => email) : author
  end

  # Input is mainly from the "Maintainer"-field in CRAN's DESCRIPTION
  # files. E.g. "Christian Buchta <christian.buchta at wu-wien.ac.at>".
  # E-mail address is not guaranteed to be valid, as can be seen above.
  #
  # @return [Author] An Author-object corresponding to the input string
  def self.new_from_string(string)
    name, email = string.mb_chars.split(/[<>]/).map(&:strip)
    if name =~ /@/
      email = name
      name = nil
    end

    return self.find_or_create_by_name("Unknown") if name.blank?

    email.downcase! unless email.blank? # NOTE: is this necessary?

    self.find_or_create(name, email)
  end

  def to_s
    self.name
  end

  def as_json(options = {})
    {"id" => id, "name" => name}
  end

  def latest_versions
    # The collect call picks the first element out of each grouped array.
    # This relies on the default ordering of the version-association.
    # I guess this could be done more efficiently in pure SQL.
    self.versions.group_by { |v| v.package_id }.values.collect { |a| a.first }
  end

end
