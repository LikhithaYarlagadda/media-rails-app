class ArticleSerializer < ActiveModel::Serializer
  attributes :id, :title, :content, :media_url, :status, :created_at, :updated_at

  belongs_to :primary_contributor, serializer: UserSerializer
  belongs_to :approved_by, serializer: UserSerializer, if: -> { object.approved_by.present? }
  has_many :comments, serializer: CommentSerializer
  has_many :reactions, serializer: ReactionSerializer
end
