# frozen_string_literal: true

require 'redmine'

Redmine::Plugin.register :redmine_issue_tag do
  name 'Redmine Issue Tag'
  author 'Taha Oztop'
  description 'Etiketlendiginiz (mention) yorumlari tek bir sayfada listeler.'
  version '0.2.0'
  url 'https://redmine.mono.tr'
  requires_redmine version_or_higher: '6.0.0'

  menu :top_menu, :issue_tag_mentions,
       { controller: 'mentions', action: 'index' },
       caption: :label_issue_tag_mentions,
       if: proc { User.current.logged? }
end

# Load the Journal patch after Rails initializes.
RedmineApp::Application.config.after_initialize do
  require_relative 'lib/redmine_issue_tag/patches/journal_patch'

  unless Journal.included_modules.include?(RedmineIssueTag::Patches::JournalPatch)
    Journal.include(RedmineIssueTag::Patches::JournalPatch)
  end
end
