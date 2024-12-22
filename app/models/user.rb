class User < ApplicationRecord
    has_secure_password
  
    # Associations
    has_many :articles, foreign_key: 'approved_by'
    has_many :article_users
    has_many :contributed_articles, through: :article_users, source: :article
  
    # Validations
    validates :username, presence: true, uniqueness: true
    validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
    validates :password, presence: true, length: { minimum: 6 }
  
    # Enum for roles
    enum role: { viewer: 'Viewer', reporter: 'Reporter', editor: 'Editor' }
  end
  