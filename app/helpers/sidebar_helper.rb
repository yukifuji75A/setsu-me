module SidebarHelper
  SIDEBAR_LINK_BASE_CLASS = "flex items-center gap-2.5 rounded-lg px-3 py-2 text-sm transition-colors".freeze
  SIDEBAR_LINK_ACTIVE_CLASS = "bg-[rgba(124,90,240,0.15)] text-white font-bold".freeze
  SIDEBAR_LINK_INACTIVE_CLASS = "text-side-link hover:bg-white/5".freeze

  # 発行済みなら閲覧画面、未発行（AI生成済み・未発行を含む）なら回答入力へ
  def sidebar_manual_path(theme)
    manual = sidebar_published_manuals[theme]
    manual ? manual_path(manual) : step1_manuals_path(theme: theme)
  end

  def sidebar_link_to(label, path, active:)
    state_class = active ? SIDEBAR_LINK_ACTIVE_CLASS : SIDEBAR_LINK_INACTIVE_CLASS
    link_to path, class: "#{SIDEBAR_LINK_BASE_CLASS} #{state_class}", aria: { current: (active ? "page" : nil) } do
      safe_join([ sidebar_link_dot(active), label ])
    end
  end

  def sidebar_link_dot(active)
    dot_class = active ? "bg-gradient-to-br from-accent-purple to-accent-pink" : "bg-transparent"
    tag.span(class: "w-1.5 h-1.5 rounded-full shrink-0 #{dot_class}", aria: { hidden: true })
  end

  # update 等で edit を再描画した場合もアクティブにするため、アクション名を複数受け付ける
  def sidebar_active?(controller, *actions)
    controller_name == controller && (actions.empty? || actions.include?(action_name))
  end

  def sidebar_manual_active?(theme)
    return false unless controller_name == "manuals"

    params[:theme] == theme || sidebar_published_manuals[theme]&.id.to_s == params[:id]
  end

  private

  def sidebar_published_manuals
    @sidebar_published_manuals ||= current_user.manuals.published.index_by(&:theme)
  end
end
