class ManualPersistService
  def initialize(user)
    @user = user
  end

  def call(theme, result)
    manual = @user.manuals.find_or_initialize_by(theme: theme)
    manual.save!

    manual.manual_ai_texts.find_or_initialize_by(section_type: :basic_spec).tap do |t|
      t.ai_text = result[:basic_spec]
      t.save!
    end

    manual.manual_ai_texts.find_or_initialize_by(section_type: :handling_guide).tap do |t|
      t.ai_text = result[:handling_guide]
      t.save!
    end

    manual
  end
end
