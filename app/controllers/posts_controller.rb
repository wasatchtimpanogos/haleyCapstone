# frozen_string_literal: true

class PostsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]
  before_action :set_post, only: %i[show edit update destroy]

  # GET /posts or /posts.json
  def index
    users = (params[:feed] == "everyone") ? User.all : current_user.leaders
    users = users.where("users.username ~* ?", params[:username]) if params[:username].present?
    users = users.where("users.species ~* ?", params[:species]) if params[:species].present?
    users = users.where("users.breed ~* ?", params[:breed]) if params[:breed].present?

    posts = Post.all
      .where(user_id: users)
      .includes(:image_attachment, user: [:image_attachment])
      .order(id: :desc)

    @pagy, @posts = pagy(posts)
  end

  # GET /posts/1 or /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts or /posts.json
  def create
    @post = Post.new(post_params.merge(user: current_user))

    respond_to do |format|
      if @post.save
        format.html { redirect_to post_url(@post), notice: "Post was successfully created." }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to post_url(@post), notice: "Post was successfully updated." }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy

    respond_to do |format|
      format.html { redirect_to posts_url, notice: "Post was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = Post.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def post_params
    params.permit(:body)
  end
end
