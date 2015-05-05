require 'spec_helper'

describe MarkdownAdapter do
  subject { Class.new { extend MarkdownAdapter } }

  describe '.markdown_html' do
    it 'generates html from markdown' do
      expect(subject.markdown_html("this text is *emphasized*")).to eq("<p>this text is <em>emphasized</em></p>")
    end
  end
end
