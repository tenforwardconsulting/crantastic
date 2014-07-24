require 'spec_helper'

describe VersionsHelper do

  it "should give a message for versions that dont use any packages" do
    assign :version, build_stubbed(:version, imports: '', suggests: '')
    helper.version_uses.should == "Does not use any package"
  end

end
