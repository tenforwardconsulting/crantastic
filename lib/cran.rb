require "rubygems"
require "nokogiri"
require "dcf"

module CRAN

  # Simple struct for one CRAN package
  class CranPackage < Struct.new(:name, :version)
    def to_s
      "#{name} (#{version})"
    end

    def to_hash
      { :name => name, :version => version }
    end

    # Packages should be sorted alphabetically, ignoring case
    def <=>(other)
      self.name.downcase <=> other.name.downcase
    end
  end

  # Enumerable list of CRAN packages.
  class Packages
    include Enumerable

    # @param [String] packages Package data
    def initialize(packages)
      @packages = []
      Dcf.parse(packages).each do |pkg|
        @packages << CranPackage.new(pkg["Package"], pkg["Version"])
      end
    end

    def each
      @packages.each { |i| yield i }
    end

    def [](i)
      @packages[i]
    end
  end

  class TaskView
    attr_reader :name, :topic, :version, :packagelist

    def initialize(ctv)
      doc = Nokogiri::XML(ctv)
      @name = (doc/"name").inner_text
      @topic = (doc/"topic").inner_text
      @version = (doc/"version").inner_text
      @packagelist = (doc/"packagelist pkg").map { |e| e.inner_text }
    end

    def to_s
      @name
    end
  end

  # Enumerable list of CRAN task views.
  class TaskViews
    include Enumerable

    def initialize(html)
      @taskviews = html.scan(/[A-Za-z]+\.html/).collect { |v| v.sub(/.html/, "") }
    end

    def each
      @taskviews.each { |i| yield i }
    end

    def [](i)
      @taskviews[i]
    end

    def size
      @taskviews.size
    end
  end

end
