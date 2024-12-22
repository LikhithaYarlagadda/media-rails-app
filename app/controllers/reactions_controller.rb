class ReactionsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_reaction_owner!, only: [:update, :destroy]

  def index
    @article = Article.find(params[:article_id])  # Find the article using the article_id parameter
    @reactions = @article.reactions  # Get the reactions for that article
    
    if @reactions.any?
      render json: @reactions  # Return the reactions in JSON format if any exist
    else
      render json: { message: 'No reactions found for this article' }, status: :no_content  # Return a 204 if no reactions exist
    end
  end

  # POST /reactable/:reactable_type/:reactable_id/reactions
  def create
    @article = Article.find_by(id: params[:article_id])
    if @article.nil?
      render json: { error: 'Article not found' }, status: :not_found
      return
    end

    @reaction = @article.reactions.new(reaction_params)
    @reaction.user = current_user
    if @reaction.save
      render json: @reaction, status: :created
    else
      render json: @reaction.errors, status: :unprocessable_entity
    end
  end

  # PUT /reactions/:id
  def update
    if @reaction.update(reaction_params)
      render json: @reaction
    else
      render json: @reaction.errors, status: :unprocessable_entity
    end
  end

  # DELETE /reactions/:id
  def destroy
    @reaction = Reaction.find_by(id: params[:id])
    if @reaction.nil?
      render json: { error: "Reaction not found" }, status: :not_found
      return
    end
    if @reaction.destroy
      render json: { message: "Reaction deleted successfully" }, status: :ok
    else
      render json: { error: "Failed to delete reaction" }, status: :unprocessable_entity
    end
  end

  private

  def reaction_params
    params.require(:reaction).permit(:reaction_type)
  end

  def set_reactable
    if params[:reactable_type] == 'Article'
      @reactable = Article.find(params[:reactable_id])
    elsif params[:reactable_type] == 'Comment'
      @reactable = Comment.find(params[:reactable_id])
    end
  end

  def set_reaction
    @reaction = Reaction.find(params[:id])
  end

  def authorize_reaction_creator
    unless @reaction.user == current_user
      render json: { error: 'Unauthorized' }, status: :forbidden
    end
  end
  
  def authorize_reaction_owner!
    reaction = Reaction.find(params[:id])
    render json: { error: 'Forbidden' }, status: :forbidden unless reaction.user == current_user
  end
end
