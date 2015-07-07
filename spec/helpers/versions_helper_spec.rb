require 'rails_helper'

RSpec.describe VersionsHelper do

  it "should give a message for versions that dont use any packages" do
    assign :version, FactoryGirl.build_stubbed(:version, imports: '', suggests: '')
    expect(helper.version_uses).to eq("Does not use any package")
  end

end
