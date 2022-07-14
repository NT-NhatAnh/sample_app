module ApplicationHelper
  # Returns the full title on a per-page basis.
  def full_title page_title
    base_title = t("Ruby_on_Rails_Tutorial_Sample_App")
    page_title.blank? ? base_title : "#{page_title} | #{base_title}"
  end
end
