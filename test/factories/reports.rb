# frozen_string_literal: true

FactoryBot.define do
  factory :report do
    sequence(:title) { |n| "#{n}番目の日報タイトル" }
    sequence(:content) { |n| "#{n}番目の日報の内容" }
    user
  end
end
