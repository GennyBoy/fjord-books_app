# frozen_string_literal: true

module ApplicationHelper
  def formatted_datetime(datetime)
    day_of_week = %w[日 月 火 水 木 金 土]
    datetime.strftime("%Y年%m月%d日(#{day_of_week[datetime.wday]}) %H:%M")
  end

  def name_or_email(user)
    user.name.empty? ? user.email : user.name
  end
end
