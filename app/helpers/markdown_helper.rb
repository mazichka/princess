module MarkdownHelper

  OPTIONS = { autolink: true, no_styles: true, safe_links_only: true, filter_html: true }

  def markdown(source, html_safe = true)
    renderer = Redcarpet::Markdown.new(Redcarpet::Render::HTML, MarkdownHelper::OPTIONS)

    html_safe? ? renderer.render(source).html_safe : renderer.render(source)
  end

end
