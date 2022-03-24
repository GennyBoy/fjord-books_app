# frozen_string_literal: true

class Books::CommentsController < ApplicationController
  before_action :set_book, only: :create

  # GET /comments or /comments.json
  def index
    @comments = Comment.all
  end

  # GET /comments/1 or /comments/1.json
  def show; end

  # GET /comments/new
  def new
    @comment = Comment.new
  end

  # GET /comments/1/edit
  def edit; end

  # POST /comments or /comments.json
  def create
    @comment = @book.comments.build(comment_params)

    respond_to do |format|
      if @comment.save
        format.html { redirect_to @book, notice: 'Comment was successfully created.' }
      else
        format.html { redirect_to @book, notice: 'エラーが発生したため保存に失敗しました。' }
      end
    end
  end

  # PATCH/PUT /comments/1 or /comments/1.json
  # TODO : 歓迎要件
  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to @comment, notice: 'Comment was successfully updated.' }
        format.json { render :show, status: :ok, location: @comment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1 or /comments/1.json
  # TODO : 歓迎要件
  def destroy
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to comments_url, notice: 'Comment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_book
    @book = Book.find(params[:book_id])
  end

  def comment_params
    params.require(:comment).permit(:content, :book_id).merge({ user_id: current_user.id })
  end
end
