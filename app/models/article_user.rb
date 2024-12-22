class ArticleUser < ApplicationRecord
  # Associations
  belongs_to :article
  belongs_to :user

  # Validations
  validates :role, presence: true

  # Enum for roles
  enum role: { primary: 'Primary', contributor: 'Contributor' }
end
