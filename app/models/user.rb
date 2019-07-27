class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  validates_uniqueness_of :email

  devise :database_authenticatable,
         :jwt_authenticatable,
         :registerable,
         :lockable,
         jwt_revocation_strategy: JWTBlacklist

  enum role: %i[user admin god]
  after_initialize :set_default_role, if:  :new_record?

  def set_default_role
    self.role ||= :user
  end
end
