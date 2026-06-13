# frozen_string_literal: true

module RedmineIssueTag
  module Patches
    # Helpers to find issue notes (journals) where a user was @-mentioned with
    # Redmine's native mention syntax.
    #
    # Redmine 6 does NOT persist mentions in any table. They live only as
    # literal "@login" text inside journals.notes. So we query the raw text
    # with a coarse LIKE pre-filter, then confirm precisely with a faithful
    # copy of Redmine's MENTION_PATTERN.
    #
    # NOTE: Unlike Redmine's notification matcher, we intentionally DO include
    # mentions that appear inside quoted text / code blocks, because for a
    # "where am I tagged" view the user wants every occurrence, not just the
    # ones that triggered a fresh email.
    module JournalPatch
      extend ActiveSupport::Concern

      # Faithful copy of Redmine's MENTION_PATTERN (lib/redmine/acts/mentionable.rb,
      # Redmine 6.x). Used WITHOUT the quote/code stripping so quoted mentions count.
      MENTION_PATTERN = /
        (?:^|\W)
        @([A-Za-z0-9_\-@\.]*?)
        (?=
          (?=[[:punct:]][^A-Za-z0-9_\/])|
          \s|
          [[:punct:]]?
          $
        )
      /ix

      class_methods do
        # Coarse, SQL-level scope: journals on issues, visible to the user
        # (issue ACL + private-notes ACL handled by Journal.visible), whose
        # notes contain the literal "@login". Precise match is done in Ruby
        # via #mentions_user? to drop false positives (e.g. prefixes / suffixes).
        def mentioning(user)
          login = user.login.to_s.downcase
          escaped = ActiveRecord::Base.sanitize_sql_like(login)

          visible(user)
            .where(journalized_type: 'Issue')
            .where.not(notes: [nil, ''])
            .where('LOWER(journals.notes) LIKE ?', "%@#{escaped}%")
            .includes(journalized: :project, user: [])
            .order(created_on: :desc)
        end
      end

      # True if this journal's notes mention the given user. Includes mentions
      # inside quoted text / code blocks (no stripping). The word-boundary regex
      # still prevents prefix/suffix false positives (e.g. "@login2", "@login'a").
      def mentions_user?(user)
        return false if notes.blank?

        target = user.login.to_s.downcase
        notes.to_s.scan(MENTION_PATTERN).flatten.map { |l| l.to_s.downcase }.include?(target)
      end
    end
  end
end
