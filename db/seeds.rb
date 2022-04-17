# frozen_string_literal: true

require 'open-uri'

# queue_adapterを変更している理由とtransactionを使っている理由は下記URLを参照
# https://bootcamp.fjord.jp/questions/779#answer_2262
ActiveStorage::AnalyzeJob.queue_adapter = :inline

print '開発環境のデータをすべて削除して初期データを投入します。よろしいですか？[Y/n]: ' # rubocop:disable Rails/Output
unless $stdin.gets.chomp == 'Y'
  puts '中止しました。' # rubocop:disable Rails/Output
  return
end

def picture_file(name)
  File.open(Rails.root.join("db/seeds/#{name}"))
end

def add_comments_to(commentable)
  comment_count = [*0..3].sample
  times = Array.new(3) do
    Faker::Time.between(from: commentable.created_at.since(10.minutes), to: commentable.created_at.since(2.days))
  end.sort
  users = User.all.to_a
  comment_count.times do |n|
    time = times[n]
    user = users.sample
    content = DummyTextJp.sentences(1)
    commentable.comments.create!(user: user, content: content, created_at: time, updated_at: time)
  end
end

puts '実行中です。しばらくお待ちください...' # rubocop:disable Rails/Output

Book.destroy_all

Book.transaction do # rubocop:disable Metrics/BlockLength
  Book.create!(
    title: 'Ruby超入門',
    memo: 'Rubyの文法の基本をやさしくていねいに解説しています。',
    author: '五十嵐 邦明',
    picture: picture_file('cho-nyumon.jpg')
  )

  Book.create!(
    title: 'チェリー本',
    memo: 'プログラミング経験者のためのRuby入門書です。',
    author: '伊藤 淳一',
    picture: picture_file('cherry-book.jpg')
  )

  Book.create!(
    title: '楽々ERDレッスン',
    memo: '実在する帳票から本当に使えるテーブル設計を導く画期的な本！',
    author: '羽生 章洋',
    picture: picture_file('erd.jpg')
  )

  55.times do
    Book.create!(
      title: Faker::Book.title,
      memo: Faker::Book.genre,
      author: Faker::Book.author,
      picture: picture_file('no-image.png')
    )
  end
end

User.destroy_all

User.transaction do
  55.times do |n|
    name = Faker::Name.name
    user = User.create!(
      email: "sample-#{n}@example.com",
      password: 'password',
      name: name,
      postal_code: "123-#{n.to_s.rjust(4, '0')}",
      address: Faker::Address.full_address,
      self_introduction: "こんにちは、#{name}です。"
    )
    user.reports.create!(
      title: "report no.#{n}",
      content: "This is #{n}th report's content"
    )
  end
end

User.order(:id).each do |user|
  image_url = Faker::Avatar.image(slug: user.email, size: '150x150')
  user.avatar.attach(io: URI.parse(image_url).open, filename: 'avatar.png')
end

# dependent: :destroy で全件削除されているはずだが念のため
Relationship.destroy_all

# 後輩が先輩を全員フォローする
User.order(id: :desc).each do |user|
  User.where('id < ?', user.id).each do |other|
    user.follow(other)
  end
end

Report.destroy_all

users = User.all.to_a
times = Array.new(55) { Faker::Time.between(from: 5.days.ago, to: 1.day.ago) }.sort
55.times do |n|
  time = times[n]
  user = users.sample
  title_length = [*10..20].sample
  title = DummyTextJp.sentences(2)[0..title_length]
  content_length = [*1..3].sample
  content = DummyTextJp.sentences(content_length).gsub(/。/, "。\n")
  user.reports.create!(title: title, content: content, created_at: time, updated_at: time)
end

# dependent: :destroy で全件削除されているはずだが念のため
Comment.destroy_all

[*Book.all.to_a, *Report.all.to_a].each do |commentable|
  add_comments_to(commentable)
end

puts '初期データの投入が完了しました。' # rubocop:disable Rails/Output
