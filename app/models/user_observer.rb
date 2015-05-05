class UserObserver < ActiveRecord::Observer
  include MarkdownAdapter

  def before_save(user)
    # Cache compiled Markdown
    user.profile_html = markdown_html(user.profile)
  end

end
