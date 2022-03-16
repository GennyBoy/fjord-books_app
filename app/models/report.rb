# frozen_string_literal: true

class Report < ApplicationRecord
  belongs_to :user
  validates :title, :user_id, presence: true

  def user
    User.find(user_id)
  end

  def formatted_created_datetime
    day_of_week = %w[日 月 火 水 木 金 土]
    created_at.strftime("%Y年%m月%d日(#{day_of_week[created_at.wday]}) %H:%M")
  end
end
