class ReactionSerializer < ActiveModel::Serializer
  attributes :id, :reaction_type, :reactable_type, :reactable_id, :created_at, :updated_at

  belongs_to :user, serializer: UserSerializer
end
