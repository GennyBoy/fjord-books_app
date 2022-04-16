# frozen_string_literal: true

class Books::CommentsController < CommentsController
  private

  def set_commentable
    @commentable = Book.find(params[:book_id])
  end
end
