# frozen_string_literal: true

class ReportsController < ApplicationController
  before_action :set_report, only: %i[show edit update destroy]
  before_action :assert_creator_is_current_user, only: %i[edit update destroy]
  before_action :initialize_comment, only: :show

  def index
    @reports = Report.order(id: :desc).page(params[:page])
  end

  def show
    @comments = @report.comments.order(:id)
  end

  def new
    @report = Report.new
  end

  def edit; end

  def create
    @report = current_user.reports.new(report_params)

    if @report.save
      redirect_to @report, notice: t('controllers.common.notice_create', name: Report.model_name.human)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @report.update(report_params)
      redirect_to @report, notice: t('controllers.common.notice_update', name: Report.model_name.human)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @report.destroy
    redirect_to reports_url, notice: t('controllers.common.notice_destroy', name: Report.model_name.human)
  end

  private

  def set_report
    @report = Report.find(params[:id])
  end

  def report_params
    params.require(:report).permit(:title, :content)
  end

  def assert_creator_is_current_user
    redirect_to reports_path, notice: t('reports.errors.forbidden_action_for_non_creators') unless @report.user == current_user
  end

  def initialize_comment
    @comment = Comment.new
  end
end
