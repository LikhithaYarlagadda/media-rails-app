class ArticlesController < ApplicationController
  before_action :authenticate_user!
  # Allow only Editors and Reporters to create and update articles
  before_action :authenticate_editor_or_reporter!, only: [:create, :update]
  # Allow only the primary contributor or approved_by editor to delete an article
  before_action :authorize_article_deletion, only: [:destroy]
  before_action :set_article, only: [:show, :update, :destroy]

  # GET /articles
  def index
    @articles = Article.includes(:approved_by, comments: :user, reactions: :user).all
    render json: @articles, include: [:comments, :reactions]
  end

  # GET /articles/:id
  def show
    @article = Article.includes(:approved_by, :comments => :user, :reactions => :user).find(params[:id])
    render json: @article, serializer: ArticleSerializer
  end

  # POST /articles
  def create
    # Create a new article associated with the current user, excluding section and primary_contributor from the params
    @article = current_user.contributed_articles.new(
      article_params.except(:section, :primary_contributor)
    )
  
    # Handle section assignment if provided
    if article_params[:section].present?
      section = Section.find_or_create_by(name: article_params[:section])
      @article.section = section  # Assign the section to the article
    end
  
    # Handle primary_contributor assignment if provided
    @article.primary_contributor = User.find(article_params[:primary_contributor]) if article_params[:primary_contributor].present?
  
    # Save the article and render the appropriate response
    if @article.save
      render json: @article, status: :created
    else
      render json: { errors: @article.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PUT /articles/:id
  def update
    if @article.update(article_params)
      render json: @article
    else
      render json: @article.errors, status: :unprocessable_entity
    end
  end

  # DELETE /articles/:id
  def destroy
    # Ensure comments and reactions are deleted with the article
    @article.comments.destroy_all
    @article.reactions.destroy_all
    @article.destroy
    head :no_content
  end

  def approve
    # Find the article by ID
    @article = Article.find_by(id: params[:id])
  
    # Ensure the article exists
    if @article.nil?
      render json: { error: 'Article not found' }, status: :not_found
      return
    end
  
    # Ensure the user is authorized to approve the article (only editors can approve)
    if current_user.editor?
      # Check if the article is already approved
      if @article.status == 'Approved'
        render json: { message: 'Article is already approved' }, status: :ok
      else
        # Approve the article
        @article.update(status: 'Approved', approved_by: current_user)
        render json: { message: 'Article approved successfully', article: @article }, status: :ok
      end
    else
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end

  def reject
    # Find the article by ID
    @article = Article.find_by(id: params[:id])
  
    # Ensure the article exists
    if @article.nil?
      render json: { error: 'Article not found' }, status: :not_found
      return
    end

    # Ensure the user is authorized to reject the article (only editors can reject)
    if current_user.editor?
      # Check if the article is already rejected
      if @article.status == 'Rejected'
        render json: { message: 'Article is already rejected' }, status: :ok
      else
        # Reject the article
        @article.update(status: 'Rejected')
        render json: { message: 'Article rejected successfully', article: @article }, status: :ok
      end
    else
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end

  private

  def article_params
    params.require(:article).permit(
      :title, :content, :media_url, :status, :approved_by, :section, :primary_contributor_id
    )
  end

  def set_article
    @article = Article.find(params[:id])
  end

  def authenticate_editor_or_reporter!
    render json: { error: 'Forbidden' }, status: :forbidden unless current_user.editor? || current_user.reporter?
  end

  def authorize_article_deletion
    article = Article.find(params[:id])
    unless article.primary_contributor == current_user || article.approved_by == current_user
      render json: { error: 'Forbidden' }, status: :forbidden
    end
  end
end
