# frozen_string_literal: true

class MentionsController < ApplicationController
  before_action :require_login

  helper :issues
  helper :custom_fields
  helper :journals

  def index
    user = User.current

    @from    = parse_date(params[:from])
    @to      = parse_date(params[:to])
    @project_id = params[:project_id].presence

    # Default window: yesterday + today. Keeps the initial page light instead
    # of scanning every journal in the database on first open.
    unless params[:set_filter] == '1' || @from || @to || @project_id
      @from = Date.current - 1
      @to   = Date.current
    end

    scope = Journal.mentioning(user)
    scope = scope.where('journals.created_on >= ?', @from.beginning_of_day) if @from
    scope = scope.where('journals.created_on <= ?', @to.end_of_day)        if @to
    if @project_id
      scope = scope
              .unscope(:includes)
              .joins('INNER JOIN issues ON issues.id = journals.journalized_id')
              .where('issues.project_id = ?', @project_id)
    end

    @projects = user_mention_projects(user, @from, @to)

    @limit = per_page_option
    @journal_count = scope.count
    @paginator = Redmine::Pagination::Paginator.new(@journal_count, @limit, params['page'])

    page_journals = scope.limit(@paginator.per_page).offset(@paginator.offset).to_a

    # Precise filter using our matcher (includes quoted mentions). Only ever
    # REMOVES rows, so it can never leak a journal visibility would have hidden.
    @journals = page_journals.select { |j| j.mentions_user?(user) }

    respond_to do |format|
      format.html { render layout: !request.xhr? }
    end
  end

  private

  def parse_date(value)
    return nil if value.blank?

    Date.parse(value.to_s)
  rescue ArgumentError
    nil
  end

  # Projects present in the user's mentions within the active date window.
  # Bounded by from/to so first-open does NOT scan the entire journals table
  # (the @login LIKE pre-filter is the expensive part on large databases).
  def user_mention_projects(user, from, to)
    rel = Journal.mentioning(user)
                 .unscope(:includes)
                 .joins('INNER JOIN issues ON issues.id = journals.journalized_id')
    rel = rel.where('journals.created_on >= ?', from.beginning_of_day) if from
    rel = rel.where('journals.created_on <= ?', to.end_of_day)        if to
    Project.where(id: rel.distinct.pluck('issues.project_id')).sorted
  end
end
