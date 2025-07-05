class PostsController < ApplicationController
  before_action :set_post, only: %i[edit update destroy]

  def index
    @posts = Post.all
  end

  def my_posts
    @posts = current_user.posts
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)

    if @post.save
      redirect_to my_posts_path, notice: 'Post criado com sucesso!'
    else
      render :new, alert: 'Erro ao criar Post!'
    end
  end

  def edit; end

  def update
    if @post.update(post_params)
      redirect_to my_posts_path, notice: 'Post atualizado com sucesso!'
    else
      render :edit, alert: 'Erro ao atualizar Post!'
    end
  end

  def destroy
    if @post.destroy
      redirect_to my_posts_path, notice: 'Post deletado com sucesso!'
    else
      redirect_to my_posts_path, alert: 'Erro ao deletar Post!'
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :description)
  end

  def set_post
    @post = Post.find(params[:id])
  end
end