# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :active_relationships, class_name: 'Relationship', foreign_key: :follower_id, dependent: :destroy, inverse_of: :follower
  has_many :followings, through: :active_relationships, source: :following

  has_many :passive_relationships, class_name: 'Relationship', foreign_key: :following_id, dependent: :destroy, inverse_of: :following
  has_many :followers, through: :passive_relationships, source: :follower

  has_one_attached :avatar

  # userを削除時にreportsも削除すべきか迷ったが、ユーザーとしては退会時に日報も消えてほしいだろうと思い一旦そうした。
  # サービス的には残したい(例えば、有益な情報を書いている日報もたくさんある)と思うので、サービスの全体設計として考える必要がありそう。
  has_many :reports, dependent: :destroy
  has_many :comments, dependent: :destroy

  def following?(user)
    active_relationships.where(following_id: user.id).exists?
  end

  def followed_by?(user)
    passive_relationships.where(follower_id: user.id).exists?
  end

  def follow(user)
    active_relationships.find_or_create_by!(following_id: user.id)
  end

  def unfollow(user)
    relationship = active_relationships.find_by(following_id: user.id)
    relationship&.destroy!
  end
end
