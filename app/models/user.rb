# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :active_relationships, class_name: 'Relationship', foreign_key: :follower_id, dependent: :destroy, inverse_of: :follower
  has_many :followings, through: :active_relationships, source: :following

  has_many :passive_relationships, class_name: 'Relationship', foreign_key: :following_id, dependent: :destroy, inverse_of: :following
  has_many :followers, through: :passive_relationships, source: :follower

  has_one_attached :avatar

  has_many :reports, dependent: :destroy

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
