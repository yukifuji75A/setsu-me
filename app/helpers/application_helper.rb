module ApplicationHelper
  def manual_serial_number(manual)
    created_at = manual.created_at.in_time_zone("Tokyo")
    era = created_at.year >= 2019 ? "R" : "H"
    "STM-#{created_at.strftime('%m%d')}#{era}#{created_at.strftime('%H%M')}"
  end
end
