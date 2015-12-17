require 'redcarpet'

module MarkdownAdapter
  def markdown_html(content)
    return content if content.blank?
    markdown_renderer.render(content)
  end

  private

  def markdown_renderer
    @_markdown_renderer ||= build_markdown_renderer
  end

  def build_markdown_renderer
    options = {
      filter_html: true,
      hard_wrap: true,
      no_images: true,
      no_styles: true,
      prettify: true,
      safe_links_only: true,
    }
    extensions = {
      autolink: true,
      tables: true,
      no_intraemphasis: true,
    }
    renderer = Redcarpet::Render::HTML.new(extensions)
    Redcarpet::Markdown.new(renderer, options)
  end
end
