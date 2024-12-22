class Article < ApplicationRecord
  belongs_to :section, optional: true
  belongs_to :approved_by, class_name: 'User', optional: true
  belongs_to :primary_contributor, class_name: 'User', foreign_key: :primary_contributor_id
  has_many :article_users
  has_many :contributors, through: :article_users, source: :user
  has_many :comments
  has_many :reactions, as: :reactable
  validates :title, :content, presence: true
end
