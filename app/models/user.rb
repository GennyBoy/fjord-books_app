# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :avatar
  has_many :follow_relationships, class_name: 'FollowRelationship',
                                  foreign_key: 'follower_id',
                                  dependent: :destroy
  has_many :following, through: :follow_relationships, source: :followed
end
