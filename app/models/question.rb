# == Schema Information
#
# Table name: questions
#
#  id         :bigint(8)        not null, primary key
#  content    :string
#  answer     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Question < ApplicationRecord
  validates :content, :answer, presence: true
  validate :content_can_only_accept_whitelisted_tags_and_attributes

  def check_answer(given_answer)
    answers = [answer, given_answer].map { |str| str.strip.downcase }
    return true if answers.first == answers.second

    answers = answers.map { |str| numbers_to_words(str) }
    return true if answers.first == answers.second

    false
  end

  private

  def numbers_to_words(string)
    string.gsub(/\d+/) { |str| str.to_i.to_words }
  end

  def content_can_only_accept_whitelisted_tags_and_attributes
    return if content.blank?
    sanitized = ActionController::Base.helpers.sanitize(content, attributes: %w(style))
    if content != sanitized
      errors.add(:content,
        "Disallowed tags or attributes are contained. It should be `#{ERB::Util.html_escape(sanitized.to_str)}`")
    end
  end
end
