class Section < ApplicationRecord
    has_many :articles
    validates :name, :dimensions, presence: true
  end
  