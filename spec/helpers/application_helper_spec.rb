require 'rails_helper'

RSpec.describe ApplicationHelper do

  it "should have a clear div helper" do
    expect(helper.clear_div).to eq(%{<div class="clear"></div>})
  end

  it "should have a title helper that figures out if the title is plural or not" do
    expect(helper.title).to eq("It's crantastic!") # The default title

    assign :title, 'Welcome'
    expect(helper.title).to eq("Welcome. It's crantastic!")

    assign :title, 'Tags'
    expect(helper.title).to eq("Tags. They're crantastic!")
  end

end
