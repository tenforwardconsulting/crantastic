require 'maruku'

module MarkdownAdapter
  def markdown_html(content)
    Maruku.new(content).to_html
  end
end
