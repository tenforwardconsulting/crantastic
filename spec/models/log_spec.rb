require 'spec_helper'

describe Log do
  it "should trim the entry count" do
    expect(Log).to receive :trim_entry_count
    Log.create!(:message => "test")
  end
end
