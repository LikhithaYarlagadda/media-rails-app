class Comment < ApplicationRecord
  belongs_to :article
  belongs_to :user
  belongs_to :parent_comment, class_name: 'Comment', optional: true
  has_many :replies, class_name: 'Comment', foreign_key: 'parent_comment_id'
  has_many :reactions, as: :reactable
  validates :content, presence: true
end
