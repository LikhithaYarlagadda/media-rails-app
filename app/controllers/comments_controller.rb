class CommentsController < ApplicationController
  # Ensure the user is authenticated before performing any comment actions
  before_action :authenticate_user!
  # Ensure only the user who created the comment can update or destroy it
  before_action :authorize_comment_owner!, only: [:update, :destroy]

  def index
    @article = Article.find(params[:article_id])  # Find the article using the article_id in the URL
    @comments = @article.comments  # Fetch the comments related to the article
    if @comments.any?
      render json: @comments  # Return the comments in JSON format if there are any
    else
      render json: { message: 'No comments found for this article' }, status: :no_content  # Return a 204 if no comments exist
    end
  end

  # POST /articles/:article_id/comments
  def create
    @article = Article.find_by(id: params[:article_id])

    if @article.nil?
      render json: { error: 'Article not found' }, status: :not_found
      return
    end

    @comment = @article.comments.new(comment_params)
    @comment.user = current_user
    if @comment.save
      render json: @comment, status: :created
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  # PUT /comments/:id
  def update
    @comment = Comment.find_by(id: params[:id])
    # Check if the comment exists
    if @comment.nil?
      render json: { error: 'Comment not found' }, status: :not_found
      return
    end

    # Proceed with the update if the comment exists
    if @comment.update(comment_params)
      render json: @comment, status: :ok
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  # DELETE /comments/:id
  def destroy
    # Ensure reactions to this comment are deleted
    @comment = Comment.find_by(id: params[:id])
    if @comment.nil?
      render json: { error: "Comment not found" }, status: :not_found
      return
    end
    if @comment.reactions.any?
      @comment.reactions.destroy_all
    end
    if @comment.destroy
      render json: { message: "Comment and associated reactions deleted successfully" }, status: :ok
    else
      render json: { error: "Failed to delete comment" }, status: :unprocessable_entity
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end

  def set_article
    @article = Article.find(params[:article_id])
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def authorize_comment_creator
    unless @comment.user == current_user
      render json: { error: 'Unauthorized' }, status: :forbidden
    end
  end
  
  def authorize_comment_owner!
    comment = Comment.find(params[:id])
    render json: { error: 'Forbidden' }, status: :forbidden unless comment.user == current_user
  end
end
