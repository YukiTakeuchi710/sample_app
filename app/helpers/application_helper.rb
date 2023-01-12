module ApplicationHelper
  # ページごとの完全なタイトルを返す
  # full_title
  # 引数が入ってない場合は''として扱う
  def full_title(page_title = '')
    # base_title 基本タイトル
    base_title = "Ruby on Rails Tutorial Sample App"
    if page_title.empty?
      base_title
    else
      "#{page_title} | #{base_title}"
    end
  end
end
