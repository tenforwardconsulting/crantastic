require 'spec_helper'

describe "/packages/show.html.erb" do

  let(:version) { FactoryGirl.build_stubbed :version }
  let(:pkg) { version.package }
  setup do
    activate_authlogic
  end

  before(:each) do
    allow(pkg).to receive(:latest) { version }
    allow(view).to receive(:current_user) { FactoryGirl.build :user }
    allow(view).to receive(:logged_in?) { true }
    tagging = Tagging.new
    tagging.package = pkg
    assign :package, pkg
    assign :version, version
    assign :tagging, tagging
  end

  it "should display the correct h1 title for a package page" do
    render
    package_title = "#{pkg.name} (#{version.version})"
    expect(rendered).to have_tag('h1', "#{pkg.name} (#{pkg.latest.version})")
  end

  it "should display ratings" do
    render
    expect(rendered).to have_tag('h2', 'Ratings')
    expect(rendered).to have_tag('span', /\(0 votes\)/)
  end

  xit "should show used packages" do
    imports = %w(graphics stats lattice grid SparseM xtable)
    imports.each { |pkg| FactoryGirl.create(:package, :name => pkg) }
    version = FactoryGirl.create(:version,
                 :imports  => imports.join(", "),
                 :suggests => "optmatch, xtable",
                 :enhances => "xtable")
    assign :version, version
    render
    expect(rendered).to have_tag("p") do
      with_tag("strong", "Uses")
      with_tag("a", "lattice")
      with_tag("a", "SparseM")
      with_tag("a", "xtable")
      with_tag("em") do
        with_tag("a", "optmatch")
      end
      with_tag("em") do
        with_tag("a", "xtable")
      end
    end
  end

end
