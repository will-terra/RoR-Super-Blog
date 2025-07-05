class PostsController < ApplicationController

  def index
    @posts = Post.all
  end

  def my_posts
    @posts = current_user.posts
  end
end
