class AddGenerationTrackingToManuals < ActiveRecord::Migration[8.0]
  def change
    add_column :manuals, :generation_count, :integer, default: 0, null: false
    add_column :manuals, :last_generated_at, :datetime
    add_column :manuals, :published_at, :datetime
  end
end
