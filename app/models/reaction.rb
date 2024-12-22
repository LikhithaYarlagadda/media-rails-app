class Reaction < ApplicationRecord
  belongs_to :reactable, polymorphic: true
  belongs_to :user
  validates :reaction_type, inclusion: { in: ['Like', 'Love', 'Dislike', 'Sad', 'Angry', 'Clap', 'Laugh'] }
end
