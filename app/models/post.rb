class Post < ApplicationRecord
  enum status: %i[draft published]
  after_initialize :set_default_status, if: :new_record?

  validates :title, presence: true
  validates :user_id, presence: true

  belongs_to :user

  private
  def set_default_status
    self.status ||= :draft
  end
end
