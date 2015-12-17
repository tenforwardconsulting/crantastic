require 'rails_helper'

RSpec.describe MarkdownAdapter do
  subject { Class.new { extend MarkdownAdapter } }

  describe '.markdown_html' do
    it 'generates html from markdown' do
      expect(subject.markdown_html("this text is *emphasized*")).to have_tag("p") do
        with_text(/this text is/)
        with_tag("em") do
          with_text(/emphasized/)
        end
      end
    end
  end
end
