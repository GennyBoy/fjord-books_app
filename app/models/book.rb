# frozen_string_literal: true

class Book < ApplicationRecord
  has_many :comments, as: :commentable, dependent: :destroy
  mount_uploader :picture, PictureUploader

  # TODO : この処理をモデルに置いて使うようにしたほうがいいか要検討
  def comment(comment)
    book.comments << comment
  end
end
