module LayoutHelper
  DEFAULT_CONTAINER_CLASS = "lg:max-w-2xl lg:mx-auto".freeze
  DEFAULT_CARD_WIDTH_CLASS = "lg:max-w-sm".freeze

  # SP（PC 未満の全ての幅）は本文をカードにして方眼の上に浮かせる。
  # サイドバーあり・共有トリセツは lg: で全幅の本文に戻し、カード表示は PC でもカードのまま
  CARD_MAIN_CLASS = "rounded-3xl border border-lp-line shadow-sm".freeze
  FULL_WIDTH_MAIN_CLASS = "lg:max-w-none lg:min-h-screen lg:rounded-none lg:border-0 lg:shadow-none".freeze

  # :sidebar … サイドバー＋全幅の本文
  # :wide    … サイドバーなしで全幅の本文（共有トリセツ）
  # :card    … サイドバーなし（未ログイン画面・プロフィール新規作成）
  def layout_mode
    if show_sidebar?
      :sidebar
    elsif content_for?(:wide_layout)
      :wide
    else
      :card
    end
  end

  def layout_body_class
    layout_mode == :card ? "flex-col items-center px-4 py-6 sm:py-10 lg:py-16" : "px-4 py-6 sm:py-10 lg:block lg:p-0"
  end

  def layout_main_class
    case layout_mode
    when :sidebar then "#{CARD_MAIN_CLASS} #{FULL_WIDTH_MAIN_CLASS} lg:pl-60"
    when :wide then "#{CARD_MAIN_CLASS} #{FULL_WIDTH_MAIN_CLASS}"
    else "#{CARD_MAIN_CLASS} lg:overflow-hidden #{layout_card_width_class}"
    end
  end

  def layout_card_width_class
    content_for?(:card_width) ? content_for(:card_width) : DEFAULT_CARD_WIDTH_CLASS
  end

  # カード表示の上に置く LP へのロゴリンク。プロフィール新規作成（ログイン済み）では出さない
  def show_card_logo?
    layout_mode == :card && !user_signed_in?
  end

  def layout_content_class
    layout_mode == :card ? "px-5 py-10" : "px-5 py-10 lg:px-10 xl:px-14 xl:py-12"
  end

  def layout_container_class
    content_for?(:container_class) ? content_for(:container_class) : DEFAULT_CONTAINER_CLASS
  end

  # 中央表示の flash を、サイドバー幅（240px）の半分だけ右にずらす
  def layout_flash_class
    show_sidebar? ? "lg:left-[calc(50%+120px)]" : ""
  end
end
