class Version < ActiveRecord::Base

  has_many :reviews

  belongs_to :package
  belongs_to :maintainer, :class_name => "Author"

  has_and_belongs_to_many :required_packages, :class_name => "Package",
                          :association_foreign_key => "required_package_id",
                          :join_table => "required_package_version"
  alias :depends :required_packages

  has_and_belongs_to_many :enhanced_packages, :class_name => "Package",
                          :association_foreign_key => "enhanced_package_id",
                          :join_table => "enhanced_package_version"
  alias :enhances :enhanced_packages

  has_and_belongs_to_many :suggested_packages, :class_name => "Package",
                          :association_foreign_key => "suggested_package_id",
                          :join_table => "suggested_package_version"
  alias :suggests :suggested_packages

  #serialize :version_changes, Hash

  scope :recent, :include => :package,
                       :order => "version.created_at DESC",
                       :conditions => "version.created_at IS NOT NULL",
                       :limit => 50

  validates_existence_of :package_id
  validates_presence_of :version
  validates_uniqueness_of :version, :scope => :package_id
  validates_length_of :name, :in => 2..255
  validates_length_of :version, :in => 1..25
  validates_length_of :title, :in => 0..255, :allow_nil => true

  attr_accessible :title, :date, :author, :description, :url, :license, :name, :version, :publicized_or_packaged,
    :maintainer_id, :package_id, :readme, :news, :depends, :suggests, :imports, :enhances

  def <=>(other)
    self.name.downcase <=> other.name.downcase
  end

  def to_s
    version
  end

  # The CRAN package field is singular, we add a pluralised alias
  def authors
    author
  end

  # Prefer publication/package date over the regular date field
  # @return [Date, DateTime]
  def date
    self.publicized_or_packaged || super
  end

  def uses
    (self.depends + self.imports).sort
  end

  def urls
    (url.split(",") rescue []).map(&:strip) + [cran_url]
  end

  def cran_url
    "http://cran.r-project.org/web/packages/#{name}"
  end

  def vname
    name + "_" + version
  end

  def reverse_depends
    reverse("required_package")
  end

  def reverse_enhances
    reverse("enhanced_package")
  end

  def reverse_suggests
    reverse("suggested_package")
  end

  def parse_depends
    parse_requirements(attributes["depends"])
  end

  def parse_suggests
    parse_requirements(attributes["suggests"])
  end

  def parse_enhances
    parse_requirements(attributes["enhances"])
  end

  def parse_imports
    parse_requirements(attributes["imports"])
  end
  alias :imports :parse_imports

  def parse_authors
    author.split(",").map { |name| Author.new_from_string(name.strip) } rescue []
  end

  def as_json(options)
    { :type => "software",
      :id => name + "_" + version,
      :title => name,
      :version => version,
      :authors => author,
      :maintainer => maintainer,
      :keywords => package.tags.map{|t| t.name},
      :description => description
    }
  end

  # Finds the previous version
  # @return [Version]
  def previous
    Version.find(:last, :conditions => ["package_id = ? AND id < ?",
                                        package_id, id])
  end

  def parse_requirements(reqs)
    reqs.split(",").map{|full| full.split(" ")[0]}.map do |name|
      Package.find_by_name name
    end.compact.sort rescue []
  end

  def reverse(key)
    pkgs = reverse_versions(key).sort.map(&:package).uniq
    return pkgs.select { |p| !p.nil? } # temporary fix ..
  end

  def reverse_versions(key)
    Version.joins("INNER JOIN #{key}_version on #{key}_version.version_id = version.id")
           .where("#{key}_version.#{key}_id = ?", self.package.id)

    # Version.find(:all, :include => :package, :conditions =>
    #              ["id IN (SELECT version_id FROM #{key}_version WHERE #{key}_id = ?)",
    #               self.package.id])
  end

end
