module StaticPagesHelper
  # 規約・プライバシーの「戻る」の行き先。
  # 未ログイン時は入口（ログイン・新規登録・LP）が複数あるため、同じサイト内の直前のページに戻す。
  # マイページはログインが必要で、未ログインで開くとログイン画面へリダイレクトされるため使わない
  def static_page_back_path
    return mypage_path if user_signed_in?

    same_site_referer_path || root_path
  end

  # サイドバーがある（ログイン済み）ときは PC ではサイドバーから移動できるため、「戻る」を PC 幅で隠す
  def static_page_back_link_class
    show_sidebar? ? "lg:hidden" : ""
  end

  private

  # 外部サイトから来た場合や、同じページを再読み込みした場合は nil
  def same_site_referer_path
    uri = URI.parse(request.referer.to_s)
    return if uri.host != request.host || uri.path == request.path

    uri.request_uri
  rescue URI::InvalidURIError
    nil
  end
end
