# frozen_string_literal: true

class Report < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy
  validates :title, :user_id, presence: true

  def user
    User.find(user_id)
  end

  # TODO : 後で考える
  def comment(comment)
    report.comments << comment
  end
end
