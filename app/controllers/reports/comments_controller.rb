# frozen_string_literal: true

class Reports::CommentsController < ApplicationController
  before_action :set_report, only: %i[create edit destroy update]
  before_action :set_comment, only: %i[destroy edit update]
  before_action :assert_creator_is_current_user, only: %i[create destroy edit update]

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
    @comment = @report.comments.build(comment_params)

    respond_to do |format|
      if @comment.save
        format.html { redirect_to @report, notice: t('controllers.common.notice_create', name: Comment.model_name.human) }
      else
        format.html { redirect_to @report, notice: 'エラーが発生したため保存に失敗しました。' }
      end
    end
  end

  # PATCH/PUT /comments/1 or /comments/1.json
  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to @report, notice: t('controllers.common.notice_update', name: Comment.model_name.human) }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1 or /comments/1.json
  def destroy
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to @report, notice: t('controllers.common.notice_destroy', name: Comment.model_name.human) }
    end
  end

  private

  def assert_creator_is_current_user
    redirect_to @report, notice: t('errors.messages.forbidden_action_for_others') unless @comment.user == current_user
  end

  def comment_params
    params.require(:comment).permit(:content).merge({ user_id: current_user.id })
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def set_report
    @report = Report.find(params[:report_id])
  end
end
