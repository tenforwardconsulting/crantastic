require 'spec_helper'

describe VersionsHelper do

  it "should give a message for versions that dont use any packages" do
    assign :version, build_stubbed(:version, imports: '', suggests: '')
    expect(helper.version_uses).to eq("Does not use any package")
  end

end
