class Post < ApplicationRecord
  enum status: %i[draft published]
  after_initialize :set_default_status, if: :new_record?

  private
  def set_default_status
    self.status ||= :draft
  end
end
